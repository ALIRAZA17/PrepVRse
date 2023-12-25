import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import requests
import os

# Initialize Firebase Admin
cred = credentials.Certificate(r"D:\projects\FYP\prepvrse\python_server\jsonFile.json")
firebase_admin.initialize_app(cred)

# Connect to Firestore
db = firestore.client()
audios_ref = db.collection("audios")
docs = audios_ref.stream()

for doc in docs:
    mydata = doc.to_dict()
    audio_url = mydata['url'] 
    break 

local_directory = r"D:\projects\FYP\prepvrse\python_server"
audio_filename = "audio1.mp3"
local_file_path = os.path.join(local_directory, audio_filename)

def download_audio(url, local_file_path):
    response = requests.get(url, stream=True)
    if response.status_code == 200:
        with open(local_file_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f"Audio has been downloaded successfully as {local_file_path}.")
    else:
        print("Failed to retrieve audio.")

if audio_url:
    download_audio(audio_url, local_file_path)
else:
    print("Audio URL not found.")
