import base64
import numpy as np
import cv2
from deepface import DeepFace
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class ImageData(BaseModel):
    image: str  # Base64-encoded image string

@app.post("/analyze")
def analyze_image(data: ImageData):
    try:
        # Remove any potential data URI header
        image_str = data.image
        if ',' in image_str:
            _, image_str = image_str.split(',', 1)
        
        # Decode and process the image
        image_bytes = base64.b64decode(image_str)
        nparr = np.frombuffer(image_bytes, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        if img is None:
            raise ValueError("The image could not be decoded")
        
        # Analyse the image for emotion using DeepFace
        result = DeepFace.analyze(img, actions=['emotion'])
        print(result)
        if isinstance(result, list):
            result = result[0]
        dominant_emotion = result['dominant_emotion']
        print(dominant_emotion)
        return {"emotion": dominant_emotion}


    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
