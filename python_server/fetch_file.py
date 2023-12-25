import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import requests
import os
from urllib.parse import unquote, urlparse
from textExtractionPDF import textExtractionPDF
from textExtractionPPTX import textExtractionPPTX

# Initialize Firebase Admin
cred = credentials.Certificate(r"D:\projects\FYP\prepvrse\python_server\jsonFile.json")
firebase_admin.initialize_app(cred)

# Connect to Firestore
db = firestore.client()
audios_ref = db.collection("pdfs")
docs = audios_ref.stream()

for doc in docs:
    mydata = doc.to_dict()
    file_url = mydata['url']
    break

local_directory = r"D:\projects\FYP\prepvrse\python_server"

def get_file_extension(file_url):
    parsed_url = urlparse(unquote(file_url))
    path = parsed_url.path
    file_name = os.path.basename(path)
    _, file_extension = os.path.splitext(file_name)
    return file_extension.lstrip('.')

def download_file(url, local_directory, file_extension):
    local_filename = f"downloaded_file.{file_extension}"
    local_file_path = os.path.join(local_directory, local_filename)
    
    response = requests.get(url, stream=True)
    if response.status_code == 200:
        with open(local_file_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f"File has been downloaded successfully as {local_file_path}.")
        return local_file_path
    else:
        print("Failed to retrieve the file.")
        return None


if file_url:
    file_extension = get_file_extension(file_url)
    if file_extension not in ['pdf', 'pptx']:
        print("The file type is not recognized or supported.")
    else:
        local_file_path = download_file(file_url, local_directory, file_extension)
        if local_file_path:
            if file_extension == 'pdf':
                print(textExtractionPDF(local_file_path))  # Process the PDF
            elif file_extension == 'pptx':
                print(textExtractionPPTX(local_file_path))  # Process the PPTX
else:
    print("File URL not found.")
