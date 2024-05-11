from pathlib import Path
from openai import OpenAI
from key import OpenApikey
client = OpenAI(api_key=OpenApikey)

def textToSpeech(text, path, voice='alloy'):
    
    speech_file_path = Path(__file__).parent / "{path}.mp3"
    response = client.audio.speech.create(
    model="tts-1",
    voice=voice,
    input=text
    )

    response.stream_to_file(speech_file_path)
