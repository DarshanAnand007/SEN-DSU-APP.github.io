from flask import Flask, json, request, jsonify
import os
import requests
import google.generativeai as genai
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
app = Flask(__name__)
genai.configure(api_key="AIzaSyBJJQMsJbz5wTUgTe1615WUkMFEJaNyCG0")
model = genai.GenerativeModel(
    "gemini-1.5-flash", generation_config={"response_mime_type": "application/json"}
)


def process_and_send_to_gemini(filepath):
    extension = os.path.splitext(filepath)[1].lower()
    text = ""

    if extension == ".pdf":
        # Use PyPDF2 for PDFs
        import PyPDF2

        with open(filepath, "rb") as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            for page in pdf_reader.pages:
                text += page.extract_text()
    elif extension == ".pptx":
        # Use python-pptx for PPTX (Not sending text to Gemini for PPTX as it's not well-suited for text processing)
        from pptx import Presentation

        prs = Presentation(filepath)
        print(
            "PPTX format is not ideal for text processing. Skipping sending text to Gemini."
        )
    elif extension == ".docx":
        # Use python-docx for DOCX
        from docx import Document

        doc = Document(filepath)
        for paragraph in doc.paragraphs:
            text += paragraph.text
    else:
        print("Unsupported file format")

    if text:
        # Send the text to Gemini API
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
"You should have a maximum of 4 topics"
"Structure the output in the following JSON format:",
"{topicname: {questionNumber: {question: "question here", difficultylevels: "difficulty", answer: "answer here", options: ["4 options here"]}}}"
]
}"""
        )
        return response.json()  # Return the response from Gemini API
    else:
        return {"error": "No text extracted from document"}


@app.route("/process_document", methods=["POST"])
def process_doc():
    # Get the uploaded file from the request
    if "document" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400
    file = request.files["document"]

    # Save the file temporarily
    filepath = os.path.join(app.config["uploads"], file.filename)
    file.save(filepath)

    # Process the document and send to Gemini
    response = process_and_send_to_gemini(filepath)

    # Remove the temporary file
    os.remove(filepath)

    # Return the response from Gemini
    return jsonify(response)


@app.route("/get_document", methods=["GET"])
def send_data():
    text = """The PDF titled "Introduction To Neural Networks" provides a comprehensive overview of neural networks, covering various topics such as the development, techniques, and comparisons with traditional computers. Here are some key points extracted from the document:

### Introduction to Neural Networks
- Development dates back to the early 1940s, with significant advances in the late 1980s.
- Neural networks (NNs) are inspired by biological neural networks and aim to create systems capable of sophisticated computations.

### Neural Network Techniques
- Traditional computers require explicit programming, whereas NNs learn from examples and adapt during a training period.

### Comparison with Traditional Computers
- Traditional computers use deductive reasoning, centralized computation, and are not fault-tolerant.
- NNs use inductive reasoning, parallel computation, and are fault-tolerant with dynamic connectivity.

### Evolution and Biological Inspiration
- The brain's ability to solve complex problems with simple neuron functions and massive parallelism inspired NNs.
- Engineers modified biological neural models for practical applications.

### Structure of Neurons
- A neuron has a cell body, dendrites (inputs), and an axon (output).
- Synapses connect axons to dendrites, and signals are propagated through these connections.

### Artificial Neural Networks (ANN)
- ANNs consist of neurons with multiple inputs and one output.
- They use a weighted sum of inputs and a threshold to produce a non-linear response.
- Key elements include layers of neurons, weights, and transfer functions.

### Training Methods
- *Supervised Learning*: Inputs and desired outputs are provided; the network adjusts weights based on errors.
- *Unsupervised Learning*: Only inputs are provided; the network self-organizes based on input features.

### Types of Neural Networks
- *Feedforward NNs*: Information flows in one direction from input to output.
- *Recurrent NNs*: Outputs are fed back into the network, suitable for time-series forecasting.
- *Auto-associative NNs*: Used for data validation and compression.

### Generalization and Overfitting
- Generalization is the ability of NNs to apply learned knowledge to new data.
- Overfitting occurs when a network performs well on training data but poorly on unseen data.
- To avoid overfitting, data is divided into training, validation, and testing sets.

### Practical Applications
- ANNs are used in image classification, speech recognition, pattern recognition, and more.
- Example project: Automated Wildfire Detection using ANNs to identify wildfires in satellite images.

The document also discusses the challenges and considerations in neural network training, including the need for large and high-quality training datasets, network architecture, and learning rates."""

    if text:
        # Send the text to Gemini API
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
                "For each identified topic, generate 3 multiple-choice questions with only easy and  hard difficulty level ",
                "Structure the output in the following JSON format:",
                "{topicname: {questionnumber: {question: "question here", difficultylevels: "difficulty", answer: "answer here", options: ["4 options here"]}}, names: ["all topic name here"]}"
                ]
                }"""
        )
        print(response.text)
        return response.text

    else:
        return {"error": "No text extracted from document"}


if __name__ == "__main__":
    app.config["UPLOAD_FOLDER"] = (
        "/tmp/uploads"  # Replace with desired temporary upload location
    )
    app.run(debug=True)
