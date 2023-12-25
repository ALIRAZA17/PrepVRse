import librosa
import numpy as np
import pyworld as pw
from pydub import AudioSegment

def convert_mp3_to_wav(mp3_path, wav_path):
    audio = AudioSegment.from_file(mp3_path, format="mp3")
    audio.export(wav_path, format="wav")

def calculate_average_pitch(audio_path, frame_size_ms=20, hop_size_ms=10):
    # Load audio file
    y, sr = librosa.load(audio_path, sr=None, dtype=np.float64)

    # Extract pitch using pyworld
    f0, _ = pw.harvest(y, sr)

    # Filter out unvoiced regions (where pitch is 0)
    voiced_pitches = f0[f0 > 0]

    # Check if there are voiced pitches
    if len(voiced_pitches) > 0:
        # Calculate average pitch
        average_pitch = np.mean(voiced_pitches)
    else:
        average_pitch = 0  # or any other default value

    return average_pitch

def get_average_pitch_from_mp3(mp3_path, frame_size_ms=20, hop_size_ms=10):
    # Convert MP3 to WAV
    wav_path = "temp.wav"
    convert_mp3_to_wav(mp3_path, wav_path)

    # Calculate average pitch
    average_pitch = calculate_average_pitch(wav_path, frame_size_ms, hop_size_ms)

    return average_pitch

# # Example usage
# mp3_path = "sample_audio.mp3"
# average_pitch = get_average_pitch_from_mp3(mp3_path, frame_size_ms=20, hop_size_ms=10)

# print(f"Average Pitch: {average_pitch:.2f} Hz")
