from vosk import Model, KaldiRecognizer
from pydub import AudioSegment
import json

def transcribe_audio(audio_file_path):
    FRAME_RATE = 16000
    CHANNELS = 1

    model = Model(model_name="vosk-model-en-us-0.22")
    rec = KaldiRecognizer(model, FRAME_RATE)
    rec.SetWords(True)

    mp3 = AudioSegment.from_mp3(audio_file_path)
    mp3 = mp3.set_channels(CHANNELS)
    mp3 = mp3.set_frame_rate(FRAME_RATE)
    
    rec.AcceptWaveform(mp3.raw_data)
    result = rec.Result()
    
    text = json.loads(result)["text"]
    return text

# # Example usage
# transcribe_audio("sample_audio.mp3")

