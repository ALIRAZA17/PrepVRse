import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from flask import Flask, jsonify
from flask_cors import CORS
from textExtractionPDF import textExtractionPDF
from textExtractionPPTX import textExtractionPPTX
from download_file import download_file

from questionGeneration import questionGeneration

app = Flask(__name__)
CORS(app)

# Initialize Firebase Admin
cred = credentials.Certificate(r"D:\projects\FYP\prepvrse\python_server\jsonFile.json")
firebase_admin.initialize_app(cred)

# Connect to Firestore and fetch the file URL
db = firestore.client()
audios_ref = db.collection("files")
docs = audios_ref.stream()
file_url = None
for doc in docs:
    mydata = doc.to_dict()
    file_url = mydata['url']
    break


@app.route('/api/extract', methods=["GET"])
def extract_questions():
    try:
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
