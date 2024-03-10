import os
import comtypes.client
import firebase_admin
from firebase_admin import credentials, firestore, storage as admin_storage
from google.cloud import storage
import shutil

# Initialize Firebase
cred = credentials.Certificate('./file.json')
firebase_admin.initialize_app(cred,{
    'storageBucket': 'prepvrse.appspot.com'
})

db = firestore.client()
bucket = admin_storage.bucket()

def upload_to_firebase_storage(local_file_path, remote_file_path):
    blob = bucket.blob(remote_file_path)
    blob.upload_from_filename(local_file_path)
    blob.make_public()
    return blob.public_url

def update_firestore(user_id, image_urls):
    doc_ref = db.collection("images").document(user_id)
    doc_ref.set({
        'imageUrls': firestore.ArrayUnion(image_urls)
    }, merge=True)

def pptx_to_pngs_and_upload(pptx_path, output_dir, user_id):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    powerpoint = comtypes.client.CreateObject("Powerpoint.Application")
    powerpoint.Visible = 1
    try:
        ppt = powerpoint.Presentations.Open(pptx_path)
        image_urls = []

        for i, slide in enumerate(ppt.Slides):
            image_path = os.path.join(output_dir, f"slide_{i+1}.png")
            slide.Export(image_path, "PNG")
            remote_path = f"images/slide_{i+1}.png"
            image_url = upload_to_firebase_storage(image_path, remote_path)
            image_urls.append(image_url)
            os.remove(image_path)

        ppt.Close()
        powerpoint.Quit()
        
        update_firestore(user_id, image_urls)
    finally:
        shutil.rmtree(output_dir)


# pptx_path = "D:\projects\FYP\prepvrse\python_server\Lec.pptx"
# output_dir = "D:\projects\FYP\prepvrse\python_server\\temp"
# user_id = "LZgH1ZyEn3Q3yy8mEzAINQrNwTN2"

# pptx_to_pngs_and_upload(pptx_path, output_dir, user_id)
