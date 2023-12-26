import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from flask import Flask, jsonify, request
from flask_cors import CORS
from textExtractionPDF import textExtractionPDF
from textExtractionPPTX import textExtractionPPTX
from download_file import download_file
from Audio_modules.pitch import get_average_pitch_from_mp3
from Audio_modules.stt import transcribe_audio
from Audio_modules.sentiment import analyze_and_classify_sentiment
from Audio_modules.vocab_level import analyze_and_classify_vocabulary_difficulty
from Audio_modules.speechrate import calculate_speech_rate_from_text_and_audio

from questionGeneration import questionGeneration

app = Flask(__name__)
CORS(app)

# Initialize Firebase Admin
cred = credentials.Certificate("./jsonFile.json")
firebase_admin.initialize_app(cred)

# Connect to Firestore and fetch the file URL
db = firestore.client()
files_ref = db.collection("files")
audios_ref = db.collection("audios")


@app.route('/api/audio_processing', methods=["GET"])
def audio_processing():
    try:
        # document_id = request.args.get('id')
        # doc_ref = db.collection("files").document(document_id)
        # doc = doc_ref.get()
        # file_url = None
        # if doc.exists:
        #     data = doc.to_dict()
        #     file_url = data["url"]
        # else:
        #     print("No such document!")

        # if not file_url:
        #     return jsonify({"error": "No URL provided"}), 400
        
        # local_file_path, _ = download_file(file_url)
        average_pitch =  get_average_pitch_from_mp3("./sample_audiomp3.mp3", frame_size_ms=20, hop_size_ms=10)
        # Speech to text
        text = transcribe_audio("./sample_audiomp3.mp3")
        # Sentiment analysis
        sentiment_score, sentiment_class = analyze_and_classify_sentiment(text)
        # Vocabulary difficulty analysis
        grade_level, difficulty_class = analyze_and_classify_vocabulary_difficulty(text)
        # Speech rate
        speech_rate = calculate_speech_rate_from_text_and_audio(text, "./sample_audiomp3.mp3")
        return jsonify({"average_pitch": average_pitch,"text": text,"sentiment_score": sentiment_score, "sentiment_class": sentiment_class,"grade_level": grade_level, "difficulty_class": difficulty_class, "speech_rate": speech_rate})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500
        


@app.route('/api/extract', methods=["GET"])
def extract_questions():
    try:
        document_id = request.args.get('id')
        doc_ref = db.collection("files").document(document_id)
        doc = doc_ref.get()
        file_url = None
        if doc.exists:
            data = doc.to_dict()
            file_url = data["url"]
        else:
            print("No such document!")

        if not file_url:
            return jsonify({"error": "No URL provided"}), 400
        
        local_file_path, file_extension = download_file(file_url)
        if local_file_path:
            if file_extension == 'pdf':
                extracted_text = textExtractionPDF(local_file_path)
            elif file_extension == 'pptx':
                extracted_text = textExtractionPPTX(local_file_path)
            else:
                return jsonify({"error": "Unsupported file type"}), 400
            generatedQuestions = questionGeneration(extracted_text)
            return jsonify({"generated_questions": generatedQuestions})
        else:
            return jsonify({"error": "Failed to download the file"}), 500

    except Exception as e:
        return jsonify({'error': str(e)}), 500




if __name__ == "__main__":
    app.run(debug=True)
