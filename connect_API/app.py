import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

# Corrected Hugging Face API URL
HF_API_URL = "https://wasteapp-clip-classifier.hf.space/api/predict"

@app.route("/")
def home():
    return "Waste Classification API is running!"

@app.route("/classify", methods=["POST"])
def classify():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    files = {"file": (file.filename, file.stream, file.mimetype)}

    try:
        response = requests.post(HF_API_URL, files=files)

        if response.status_code == 200:
            return jsonify(response.json())
        else:
            return jsonify({"error": f"Failed to classify image. HF Response: {response.text}"}), 500

    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"Request failed: {e}"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
