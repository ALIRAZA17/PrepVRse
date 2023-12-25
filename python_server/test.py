import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate(r"D:\projects\FYP\prepvrse\python_server\jsonFile.json")
firebase_admin.initialize_app(cred)



db = firestore.client()

audios_ref = db.collection("audios")

docs = audios_ref.stream()

for doc in docs:
    print(f"Document ID: {doc.id}")
    print(f"Document Data: {doc.to_dict()}") 
    break 
