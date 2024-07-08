# Interactive Learning App

This application allows you to upload a PDF, process it using GeminiAPI, and generate multiple-choice questions (MCQs) to create an interactive learning environment. Students can use this to learn or take tests, while teachers can provide tests or viva questions to students.

## Features

- Upload PDFs and extract content using GeminiAPI.
- Generate MCQs automatically from the extracted content.
- Create interactive quizzes for students.
- Useful for both learning and assessment purposes.

## Installation

### Prerequisites

Ensure you have the following installed on your machine:

- Python 3.x
- pip (Python package installer)

### Steps

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/interactive-learning-app.git
    cd interactive-learning-app
    ```

2. **Create a virtual environment:**

    ```bash
    python3 -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```

3. **Install the required dependencies:**

    ```bash
    pip install -r requirements.txt
    ```

4. **Set up environment variables:**

    Create a `.env` file in the project root directory and add your GeminiAPL API key:

    ```plaintext
    GEMINIAPI_API_KEY=your_api_key_here
    ```

5. **Run the application:**

    ```bash
    python app.py
    ```

## Usage

1. **Upload a PDF:**
   - Navigate to the upload section.
   - Select the PDF you want to process.

2. **Generate MCQs:**
   - The app will process the PDF using GeminiAPI and generate MCQs.
   - Review and edit the generated questions if needed.

3. **Create a Quiz:**
   - Use the generated MCQs to create a quiz.
   - Share the quiz link with students for interactive learning or assessment.
