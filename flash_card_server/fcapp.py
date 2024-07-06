from flask import Flask, request, jsonify
import os
import requests
import google.generativeai as genai
from flask_cors import CORS
import uuid
import PyPDF2

app = Flask(__name__)
CORS(app)

genai.configure(api_key="AIzaSyBJJQMsJbz5wTUgTe1615WUkMFEJaNyCG0")
model = genai.GenerativeModel(
    "gemini-1.5-flash", generation_config={"response_mime_type": "application/json"}
)

master_dictionary = {"ids": []}

@app.route("/get_document", methods=["POST"])
def send_data():
    if "document" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400
    
    file = request.files["document"]
    
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400
    
    extension = os.path.splitext(file.filename)[1].lower()
    if extension != ".pdf":
        return jsonify({"error": "Unsupported file format, only PDFs are allowed"}), 400
    
    filepath = os.path.join("/tmp", file.filename)
    file.save(filepath)
    
    text = ""
    with open(filepath, "rb") as pdf_file:
        pdf_reader = PyPDF2.PdfReader(pdf_file)
        for page in pdf_reader.pages:
            text += page.extract_text()
    
    os.remove(filepath)
    
    if text:
        response = model.generate_content(
            """{
                "instructions": [
                "Here is an article. Please read it carefully and then answer the following questions: ",
                "1. Identify the main topics discussed in the article."
                ],
                "text":"""
            + text
            + """,
                "desired_output": [
                "For each identified topic, generate 3 multiple-choice questions with only easy and hard difficulty level ",
                "Structure the output in the following JSON format:",
                "{topicname: {questionnumber: {question: "question here", difficultylevels: "difficulty", answer: "answer here", options: ["4 options here"]}}, names: ["all topic name here"]}"
                ]
                }"""
        )
        
        response_content = response.json()
        doc_id = str(uuid.uuid4())
        master_dictionary[doc_id] = {"content": response_content, "name": file.filename}
        master_dictionary["ids"].append(doc_id)
        
        return jsonify(response_content)
    else:
        return jsonify({"error": "No text extracted from document"})


@app.route("/upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "No selected file"}), 400

    # Save the file to a desired location
    file.save(f"../uploads/{file.filename}")

    return jsonify({"message": "File successfully uploaded"}), 200


if __name__ == "__main__":
    app.config["uploads"] = "../uploads"  # Set the uploads folder
    app.run(host="0.0.0.0", port=5000)
