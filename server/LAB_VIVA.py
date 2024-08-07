from flask import Flask, json, request, jsonify
import os
import PyPDF2
import google.generativeai as genai
from flask_cors import CORS
import pandas as pd
import datetime

app = Flask(__name__)
CORS(app)
genai.configure(api_key="AIzaSyBJJQMsJbz5wTUgTe1615WUkMFEJaNyCG0")
model = genai.GenerativeModel(
    "gemini-1.5-pro", generation_config={"response_mime_type": "application/json"}
)


def process_and_send_to_gemini(filepath):
    text = ""
    print(f"Processing file: {filepath}")

    # Extract text from PDF
    with open(filepath, "rb") as pdf_file:
        pdf_reader = PyPDF2.PdfReader(pdf_file)
        for page in pdf_reader.pages:
            text += page.extract_text()

    print(f"Extracted text: {text[:500]}...")  # Print first 500 characters for debugging

    if text:
        # Send the text to Gemini API
        response = model.generate_content(
            json.dumps(
                {
                    "instructions": [
                        "Here is an article. Please read it carefully and then answer the following questions: ",
                        "1. Identify the main topics discussed in the article.",
                    ],
                    "text": text,
                    "desired_output": [
                        "For each identified topic, generate 3 multiple-choice questions with coding snippets, only easy and hard difficulty levels.",
                        "You should have a maximum of 4 topics.",
                        "Structure the output in the following JSON format:",
                        "{topicname: {questionNumber: {question: 'question here', difficultyLevel: 'difficulty', code_snippet: 'code here', answer: 'answer here', options: ['4 options here']}}}",
                    ],
                    "examples": {
                        "good": [
                            {
                                "Python Basics": {
                                    "1": {
                                        "question": "What will be the output of the following code snippet?",
                                        "difficultyLevel": "easy",
                                        "code_snippet": "print(2 + 2)",
                                        "answer": "4",
                                        "options": ["3", "4", "5", "6"],
                                    },
                                    "2": {
                                        "question": "What is the result of the following code snippet?",
                                        "difficultyLevel": "hard",
                                        "code_snippet": "x = [1, 2, 3]\nx.append(4)\nprint(x)",
                                        "answer": "[1, 2, 3, 4]",
                                        "options": ["[1, 2, 3]", "[1, 2, 3, 4]", "[1, 2, 3, None]", "Error"],
                                    },
                                    "3": {
                                        "question": "What will be printed by this code snippet?",
                                        "difficultyLevel": "easy",
                                        "code_snippet": "for i in range(3):\n    print(i)",
                                        "answer": "0\n1\n2",
                                        "options": ["1\n2\n3", "0\n1\n2", "Error", "None"],
                                    },
                                }
                            },
                            {
                                "Data Structures": {
                                    "1": {
                                        "question": "What does the following code snippet do?",
                                        "difficultyLevel": "easy",
                                        "code_snippet": "stack = []\nstack.append(1)\nstack.append(2)\nstack.pop()",
                                        "answer": "Adds 1 and 2 to the stack and then removes 2",
                                        "options": [
                                            "Adds 1 and 2 to the stack and then removes 1",
                                            "Adds 1 and 2 to the stack and then removes 2",
                                            "Removes 1 and 2 from the stack",
                                            "Only adds 1 to the stack",
                                        ],
                                    },
                                    "2": {
                                        "question": "What is the output of this code snippet?",
                                        "difficultyLevel": "hard",
                                        "code_snippet": "queue = [1, 2, 3]\nqueue.pop(0)\nprint(queue)",
                                        "answer": "[2, 3]",
                                        "options": ["[1, 2, 3]", "[3, 2, 1]", "[2, 3]", "[3, 2]"],
                                    },
                                    "3": {
                                        "question": "What is the purpose of this code snippet?",
                                        "difficultyLevel": "easy",
                                        "code_snippet": "def factorial(n):\n    return 1 if n == 0 else n * factorial(n - 1)",
                                        "answer": "Calculate the factorial of a number",
                                        "options": [
                                            "Calculate the sum of numbers",
                                            "Calculate the factorial of a number",
                                            "Calculate the power of a number",
                                            "Find the maximum of a list",
                                        ],
                                    },
                                }
                            },
                            {
                                "Algorithms": {
                                    "1": {
                                        "question": "What is the output of the following code snippet?",
                                        "difficultyLevel": "hard",
                                        "code_snippet": "def binary_search(arr, target):\n    left, right = 0, len(arr) - 1\n    while left <= right:\n        mid = (left + right) // 2\n        if arr[mid] == target:\n            return mid\n        elif arr[mid] < target:\n            left = mid + 1\n        else:\n            right = mid - 1\n    return -1\nprint(binary_search([1, 2, 3, 4, 5], 4))",
                                        "answer": "3",
                                        "options": ["2", "3", "4", "5"],
                                    },
                                    "2": {
                                        "question": "What does this code snippet do?",
                                        "difficultyLevel": "easy",
                                        "code_snippet": "def bubble_sort(arr):\n    n = len(arr)\n    for i in range(n):\n        for j in range(0, n-i-1):\n            if arr[j] > arr[j+1]:\n                arr[j], arr[j+1] = arr[j+1], arr[j]\n    return arr\nprint(bubble_sort([64, 34, 25, 12, 22, 11, 90]))",
                                        "answer": "Sorts the array in ascending order",
                                        "options": [
                                            "Sorts the array in ascending order",
                                            "Sorts the array in descending order",
                                            "Reverses the array",
                                            "Shuffles the array",
                                        ],
                                    },
                                    "3": {
                                        "question": "What is the result of this code snippet?",
                                        "difficultyLevel": "hard",
                                        "code_snippet": "def quick_sort(arr):\n    if len(arr) <= 1:\n        return arr\n    pivot = arr[len(arr) // 2]\n    left = [x for x in arr if x < pivot]\n    middle = [x for x in arr if x == pivot]\n    right = [x for x in arr if x > pivot]\n    return quick_sort(left) + middle + quick_sort(right)\nprint(quick_sort([3, 6, 8, 10, 1, 2, 1]))",
                                        "answer": "[1, 1, 2, 3, 6, 8, 10]",
                                        "options": ["[1, 1, 2, 3, 6, 8, 10]", "[10, 8, 6, 3, 2, 1, 1]", "[3, 6, 8, 10, 1, 2, 1]", "[1, 2, 3, 6, 8, 10, 1]"],
                                    },
                                }
                            },
                        ],
                        "bad": [
                            {
                                "Python Basics": {
                                    "question1": {
                                        "question": "What is the color of the sky?",
                                        "difficultyLevel": "easy",
                                        "answer": "Blue",
                                        "options": ["Blue", "Green", "Red", "Yellow"],
                                    },
                                    "question2": {
                                        "question": "How many continents are there?",
                                        "difficultyLevel": "hard",
                                        "answer": "Seven",
                                        "options": ["Five", "Six", "Seven", "Eight"],
                                    },
                                    "3": {
                                        "question": "Which is the largest ocean?",
                                        "difficultyLevel": "easy",
                                        "answer": "Pacific Ocean",
                                        "options": [
                                            "Atlantic Ocean",
                                            "Indian Ocean",
                                            "Arctic Ocean",
                                            "Pacific Ocean",
                                        ],
                                    },
                                }
                            },
                            {
                                "Python Basics": {
                                    "1": {
                                        "question": "What is it?",
                                        "difficultyLevel": "easy",
                                        "answer": "",
                                        "options": ["", "", "", ""],
                                    },
                                    "2": {
                                        "question": "Explain the concept.",
                                        "difficultyLevel": "hard",
                                        "answer": "",
                                        "options": ["", "", "", ""],
                                    },
                                    "3": {
                                        "question": "What do you think?",
                                        "difficultyLevel": "easy",
                                        "answer": "",
                                        "options": ["", "", "", ""],
                                    },
                                }
                            },
                        ],
                    },
                }
            )
        )
        print(f"Response from Gemini: {response.text[:500]}...")  # Print first 500 characters of response for debugging
        return response.text  # Return the response from Gemini API
    else:
        return {"error": "No text extracted from document"}


UPLOAD_FOLDER = os.path.join(os.getcwd(), "uploads")
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


@app.route("/store_data", methods=["POST"])
def upload_json():
    try:
        # Get JSON data from the request
        data = request.get_json()
        if not data:
            return jsonify({"error": "Invalid JSON data"}), 400

        # Check if the JSON data is a list of dictionaries
        if not isinstance(data, list) or not all(isinstance(item, dict) for item in data):
            return jsonify({"error": "JSON data must be a list of dictionaries"}), 400

        # Convert JSON to DataFrame
        df = pd.DataFrame(data)

        # Generate a unique filename based on the current timestamp
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        excel_file_path = os.path.join(UPLOAD_FOLDER, f"data_{timestamp}.xlsx")
        csv_file_path = os.path.join(UPLOAD_FOLDER, f"data_{timestamp}.csv")

        # Save DataFrame to Excel and CSV files
        df.to_excel(excel_file_path, index=False)
        df.to_csv(csv_file_path, index=False)

        return jsonify({
            "message": "File saved successfully",
            "excel_path": excel_file_path,
            "csv_path": csv_file_path,
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/process_document", methods=["POST"])
def process_doc():
    print("Enter process doc")
    print(request.files)  # Debugging line to print all files in the request

    # Get the uploaded file from the request
    if "document" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400
    file = request.files["document"]
    print(f"Received file: {file.filename}")  # Debugging line to confirm file receipt

    # Save the file temporarily
    filepath = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(filepath)
    print(f"File saved to: {filepath}")

    # Process the document and send to Gemini
    response = process_and_send_to_gemini(filepath)

    # Remove the temporary file
    os.remove(filepath)
    print(f"File removed: {filepath}")

    # Return the response from Gemini
    return jsonify(response)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
