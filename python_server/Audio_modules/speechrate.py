from pydub import AudioSegment
import speech_recognition as sr

def calculate_speech_rate_from_text_and_audio(text, audio_path):
    # Load the audio file
    audio_segment = AudioSegment.from_mp3(audio_path)

    # Count the number of words in the text
    words = len(text.split())

    # Get the duration of the audio in seconds
    audio_duration_seconds = len(audio_segment.raw_data) / (audio_segment.sample_width * audio_segment.frame_rate)

    # Calculate speech rate in words per minute (WPM)
    speech_rate = (words / audio_duration_seconds) * 60

    return speech_rate

# Example usage
# audio_path = "sample_audio.mp3"  # Replace with the actual path to your audio file
# text = "Your text goes here."

# speech_rate = calculate_speech_rate_from_text_and_audio(text, audio_path)

# print(f"Speech Rate: {speech_rate:.2f} words per minute")
