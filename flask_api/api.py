import io
from flask import Flask, request, jsonify
from vosk import Model, KaldiRecognizer
from pydub import AudioSegment

app = Flask(__name__)

FRAME_RATE = 16000
CHANNELS = 1
model = Model(model_name="vosk-model-en-us-0.22")

@app.route('/recognize-speech', methods=['POST'])
def recognize_speech():
    try:
        audio_data = request.data
        audio_stream = io.BytesIO(audio_data)
        mp3 = AudioSegment.from_file(audio_stream,format="mp3")
        mp3 = mp3.set_channels(CHANNELS)
        mp3 = mp3.set_frame_rate(FRAME_RATE)
        rec = KaldiRecognizer(model, FRAME_RATE)
        rec.SetWords(True)
        rec.AcceptWaveform(mp3.raw_data)
        result = rec.Result()

        text = jsonify.loads(result)["text"]

        return jsonify({'text': text})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
