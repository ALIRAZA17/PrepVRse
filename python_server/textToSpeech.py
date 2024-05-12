from pathlib import Path
from openai import OpenAI
from key import OpenApikey
client = OpenAI(api_key=OpenApikey)
import random

voices = ['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer']

# E.g path='speech.mp3' / 'speech.wav'

def textToSpeech(text, path):
    voice = random.choice(voices) 
    speech_file_path = Path(__file__).parent / f"{path}"
    response = client.audio.speech.create(
    model="tts-1",
    voice=voice,
    input=text
    )

    response.stream_to_file(speech_file_path)

    return speech_file_path