import cv2
import numpy as np
import tensorflow as tf
from tensorflow.keras.applications import VGG16
from tensorflow.keras.layers import Flatten, Dense
from PIL import Image
import io

# Define target image dimensions
target_width, target_height = 224, 224
use_face_detection = True  # Set to True if you want to use face detection

# Define skin type classes
skin_types = ['Normal', 'Oily', 'Dry', 'Combination']
num_classes = len(skin_types)

# Define face detection function (optional)
def detect_face(image):
    # Your face detection logic here
    pass

# Define image preprocessing function
def preprocess_image(image):
    image = image / 255.0
    image = tf.image.resize(image, (target_width, target_height))
    return image

# Load pre-trained VGG16 model
base_model = VGG16(weights='imagenet', include_top=False, input_shape=(target_width, target_height, 3))
base_model.trainable = False

x = base_model.output
x = Flatten()(x)
x = Dense(units=1024, activation='relu')(x)
predictions = Dense(units=num_classes, activation='softmax')(x)

model = tf.keras.Model(inputs=base_model.input, outputs=predictions)

# Ask the user to choose between uploading an image or taking a photo
print("Choose an option:")
print("1. Upload an image")
print("2. Take a photo")

choice = input("Enter your choice (1 or 2): ")

if choice == '1':
    # Ask the user to provide the path to the uploaded image
    image_path = input("Enter the path to the uploaded image: ")

    try:
        # Load the image from the specified path
        frame = cv2.imread(image_path)
        if frame is None:
            raise FileNotFoundError(f"Error loading image at {image_path}. Please check the file path.")
    except Exception as e:
        print(f"Error: {e}")
        exit()
elif choice == '2':
    # Open webcam for capture
    cap = cv2.VideoCapture(0)
    ret, frame = cap.read()
    cap.release()
else:
    print("Invalid choice. Exiting.")
    exit()

if use_face_detection:
    # Apply face detection here if needed
    pass

# Preprocess the image
preprocessed_image = preprocess_image(frame)
preprocessed_image = np.expand_dims(preprocessed_image, axis=0)

# Make prediction
prediction = model.predict(preprocessed_image)[0]
predicted_class_index = np.argmax(prediction)
predicted_skin_type = skin_types[predicted_class_index]

# Display the image with predicted skin type
cv2.putText(frame, f"Skin Type: {predicted_skin_type}", (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
cv2.imshow('Skin Type Analyzer', frame)
cv2.waitKey(0)
cv2.destroyAllWindows()