import cv2
import numpy as np
import asyncio
import requests
import tensorflow.lite as tflite
from fastapi import FastAPI
from typing import List

app = FastAPI()

# Load TFLite Models
FACE_MODEL_PATH = "models/face_detection_full_range_sparse.tflite"
EMOTION_MODEL_PATH = "models/emotion_classification.tflite"     # TODO: UPDATE PATH

# Initialize TFLite Interpreters
face_interpreter = tflite.Interpreter(model_path=FACE_MODEL_PATH)
emotion_interpreter = tflite.Interpreter(model_path=EMOTION_MODEL_PATH)

# Allocate tensors (required for TFLite models)
face_interpreter.allocate_tensors()
emotion_interpreter.allocate_tensors()


# Run face detection model
def detect_faces(frame: np.ndarray):
    """
    Detects distinct faces from the given frame using TFLite model.
    Returns bounding box coordinates of detected faces.
    """
    # Preprocess the image (resize, normalize)
    input_details = face_interpreter.get_input_details()
    output_details = face_interpreter.get_output_details()

    height, width, _ = frame.shape
    input_shape = input_details[0]['shape']  # Example: (1, 128, 128, 3)
    resized_frame = cv2.resize(frame, (input_shape[1], input_shape[2]))
    normalized_frame = np.expand_dims(resized_frame / 255.0, axis=0).astype(np.float32)

    # Run inference
    face_interpreter.set_tensor(input_details[0]['index'], normalized_frame)
    face_interpreter.invoke()
    face_detections = face_interpreter.get_tensor(output_details[0]['index'])

    # Convert detections to bounding box coordinates
    faces = []
    for detection in face_detections[0]:  # Assuming first batch
        x, y, w, h = detection[:4]  # Extract bounding box
        x, y, w, h = int(x * width), int(y * height), int(w * width), int(h * height)
        faces.append((x, y, w, h))
    return faces


# Run emotion classification model
def analyze_emotion(face: np.ndarray):
    """
    Predicts the emotion of a given face image using TFLite model.
    Returns an emotion label.
    """
    input_details = emotion_interpreter.get_input_details()
    output_details = emotion_interpreter.get_output_details()

    input_shape = input_details[0]['shape']  # Example: (1, 48, 48, 1) for grayscale
    resized_face = cv2.resize(face, (input_shape[1], input_shape[2]))
    normalized_face = np.expand_dims(resized_face / 255.0, axis=(0, -1)).astype(np.float32)

    # Run inference
    emotion_interpreter.set_tensor(input_details[0]['index'], normalized_face)
    emotion_interpreter.invoke()
    predictions = emotion_interpreter.get_tensor(output_details[0]['index'])

    # Get the emotion label
    emotions = ["Happy", "Neutral", "Sad", "Surprised", "Angry"]
    emotion_label = emotions[np.argmax(predictions)]
    return emotion_label


# Capture frames and process frames periodically 
async def process_video_stream():
    """
    Captures video stream, extracts frames every X seconds, detects faces,
    analyzes emotions, and sends results to another backend API.
    """
    cap = cv2.VideoCapture(0)  # Use default camera

    while True:
        ret, frame = cap.read()
        if not ret:
            print("Error: Could not read frame.")
            continue

        # Detect Faces
        faces = detect_faces(frame)

        # Extract & Analyze Emotions
        face_results = []
        for (x, y, w, h) in faces:
            face_crop = frame[y:y+h, x:x+w]  # Crop detected face
            emotion = analyze_emotion(face_crop)
            face_results.append({"x": x, "y": y, "width": w, "height": h, "emotion": emotion})

        # Convert frame to base64 (CURRENTLY NOT USED)
        # _, buffer = cv2.imencode('.jpg', frame)
        # frame_base64 = base64.b64encode(buffer).decode("utf-8")

        # Send Data to Another Backend API
        payload = {
            "faces": face_results  # Detected emotions
        }

        try:
            response = requests.post("http://your-backend.com/process_data", json=payload)
            if response.status_code == 200:
                print("Sent data successfully:", response.json())
            else:
                print(f"Error sending data: {response.status_code}, {response.text}")
        except Exception as e:
            print(f"Failed to send data: {e}")


if __name__ == "__main__":
    import uvicorn
    loop = asyncio.get_event_loop()
    loop.create_task(process_video_stream())  # Run video processing asynchronously
    uvicorn.run(app, host="0.0.0.0", port=8000)
