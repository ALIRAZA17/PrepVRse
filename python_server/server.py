from flask import Flask, jsonify, request
from flask_cors import CORS
from pptx_to_png import pptx_to_pngs_and_upload
from interviewQuestionGeneration import interviewQuestionGeneration
from textExtractionPDF import textExtractionPDF
from textExtractionPPTX import textExtractionPPTX
from download_file import download_file
from Audio_modules.pitch import get_average_pitch_from_mp3
from Audio_modules.stt import transcribe_audio
from Audio_modules.sentiment import analyze_and_classify_sentiment
from Audio_modules.vocab_level import analyze_and_classify_vocabulary_difficulty
from Audio_modules.speechrate import calculate_speech_rate_from_text_and_audio

from questionGeneration import questionGeneration
from relevanceChecking import relevanceChecking
from lineSeparator import lineSeparator
from firebase_admin_instance import get_firestore_instance


from pydub import AudioSegment
import os

app = Flask(__name__)
CORS(app)

# Use Firestore instance
db = get_firestore_instance()


@app.route("/api/audio_processing", methods=["POST"])
def audio_processing():
    try:
        extracted_text = ""
        data = request.json
        audio_Path = data.get("audioFilePath")
        user_id = data.get("userId")

        # Getting filePath from firebase
        sessions_ref = db.collection("sessions").document(user_id)
        sessions = sessions_ref.get().to_dict()["sessions"]
        last_session = sessions[-1]
        file_path = last_session["filePath"]

        # Downloading file
        local_file_path, file_extension = download_file(file_path)
        if local_file_path:
            if file_extension == "pdf":
                extracted_text = textExtractionPDF(local_file_path)
            elif file_extension == "pptx":
                extracted_text = textExtractionPPTX(local_file_path)
            else:
                return jsonify({"error": "Unsupported file type"}), 400

        # downloading audio file locally
        audio_local_file_path, _ = download_file(audio_Path)

        # Convert WAV to MP3
        mp3_file_path = audio_local_file_path.replace(".wav", ".mp3")
        AudioSegment.from_wav(audio_local_file_path).export(mp3_file_path, format="mp3")

        average_pitch = get_average_pitch_from_mp3(
            mp3_file_path, frame_size_ms=20, hop_size_ms=10
        )
        # Speech to text
        text = transcribe_audio(mp3_file_path)
        # Punctuated text
        text = lineSeparator(text)
        # Relevance
        relevance = relevanceChecking(extracted_text, text)
        # Sentiment analysis
        sentiment_score, sentiment_class = analyze_and_classify_sentiment(text)
        # Vocabulary difficulty analysis
        grade_level, difficulty_class = analyze_and_classify_vocabulary_difficulty(text)
        # Speech rate
        speech_rate = calculate_speech_rate_from_text_and_audio(text, mp3_file_path)

        # Clean up temporary WAV file
        os.remove(local_file_path)
        os.remove(mp3_file_path)
        os.remove(audio_local_file_path)

        # Update reportGenerated key in the last session
        last_session["reportGenerated"] = {
            "average_pitch": average_pitch,
            "text": text,
            "sentiment_score": sentiment_score,
            "sentiment_class": sentiment_class,
            "grade_level": grade_level,
            "difficulty_class": difficulty_class,
            "speech_rate": speech_rate,
            "relevance": relevance,
        }

        # Update Firestore document
        sessions_ref.update({"sessions": sessions})

        return jsonify(
            {
                "average_pitch": average_pitch,
                "text": text,
                "sentiment_score": sentiment_score,
                "sentiment_class": sentiment_class,
                "grade_level": grade_level,
                "difficulty_class": difficulty_class,
                "speech_rate": speech_rate,
                "relevance": relevance,
            }
        )

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/extract", methods=["GET"])
def extract_questions():
    try:
        document_id = request.args.get("id")
        user_id = request.args.get("userId")
        is_interview = request.args.get("isInterview", "false").lower() == "true"
        jd = request.args.get("jd", "")
        position = request.args.get("position", "")
        experience = request.args.get("experience", "")

        doc_ref = db.collection("files").document(document_id)
        doc = doc_ref.get()
        if not doc.exists:
            return jsonify({"error": "No such document"}), 400

        file_url = doc.to_dict().get("url")
        if not file_url:
            return jsonify({"error": "No URL provided"}), 400

        local_file_path, file_extension = download_file(file_url)
        if not local_file_path:
            return jsonify({"error": "Failed to download the file"}), 500

        if file_extension in ["pdf", "pptx"]:
            extracted_text = (
                textExtractionPDF(local_file_path)
                if file_extension == "pdf"
                else textExtractionPPTX(local_file_path)
            )

            if is_interview:
                formData = {"jd": jd, "position": position, "experience": experience}
                generatedQuestions = interviewQuestionGeneration(
                    extracted_text, formData
                )
            else:
                generatedQuestions = questionGeneration(extracted_text)

            return jsonify(
                {
                    "generated_questions": generatedQuestions,
                    "extracted_text": extracted_text,
                }
            )
        else:
            return jsonify({"error": "Unsupported file type"}), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
