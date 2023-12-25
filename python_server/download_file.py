import requests
import os
from urllib.parse import unquote, urlparse


def download_file(url):
    parsed_url = urlparse(unquote(url))
    path = parsed_url.path
    file_name = os.path.basename(path)
    _, file_extension = os.path.splitext(file_name)
    file_extension = file_extension.lstrip('.')

    local_directory = r"D:\projects\FYP\prepvrse\python_server"
    local_file_path = os.path.join(local_directory, file_name)

    if os.path.exists(local_file_path):
        os.remove(local_file_path)

    response = requests.get(url, stream=True)
    if response.status_code == 200:
        with open(local_file_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        return local_file_path, file_extension
    else:
        return None, None
