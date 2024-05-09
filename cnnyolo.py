import cv2
import numpy as np
import tensorflow as tf
from tensorflow.keras.applications import VGG16
from tensorflow.keras.layers import Flatten, Dense
from PIL import Image
import io

# Specify the paths to yolov3.weights and yolov3.cfg
weights_path = "path/to/yolov3.weights"
config_path = "path/to/yolov3.cfg"

# Load YOLO model
net = cv2.dnn.readNet(weights_path, config_path)
layer_names = net.getLayerNames()
output_layers = [layer_names[i - 1] for i in net.getUnconnectedOutLayers()]

# Define target image dimensions
target_width, target_height = 224, 224
use_face_detection = True  # Set to True if you want to use face detection

# Define skin type classes
skin_types = ['Normal', 'Oily', 'Dry']
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

# Ask the user to choose between uploading a picture or taking a photo
print("Choose an option:")
print("1. Upload a picture")
print("2. Take a photo")

choice = input("Enter your choice (1 or 2): ")

if choice == '1':
    # Ask the user to provide the path to the uploaded image
    image_path = input("Enter the path to the uploaded image: ")
    frame = cv2.imread(image_path)
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
    detected_face = detect_face(frame)
    if detected_face is not None:
        frame = detected_face

# Preprocess the image
preprocessed_image = preprocess_image(frame)
preprocessed_image = np.expand_dims(preprocessed_image, axis=0)

# Make prediction with YOLO for object detection
blob = cv2.dnn.blobFromImage(frame, 0.00392, (416, 416), (0, 0, 0), True, crop=False)
net.setInput(blob)
outs = net.forward(output_layers)

# Process YOLO output for skin type classification
class_ids = []
for out in outs:
    for detection in out:
        scores = detection[5:]
        class_id = np.argmax(scores)
        confidence = scores[class_id]
        if confidence > 0.5:
            center_x = int(detection[0] * frame.shape[1])
            center_y = int(detection[1] * frame.shape[0])
            w = int(detection[2] * frame.shape[1])
            h = int(detection[3] * frame.shape[0])
            x = int(center_x - w / 2)
            y = int(center_y - h / 2)
            class_ids.append(class_id)
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)

# Classify skin type based on detected objects
if len(class_ids) > 0:
    preprocessed_image = preprocess_image(frame)
    preprocessed_image = np.expand_dims(preprocessed_image, axis=0)
    prediction = model.predict(preprocessed_image)[0]
    predicted_class_index = np.argmax(prediction)
    predicted_skin_type = skin_types[predicted_class_index]

    # Display the image with predicted skin type and object detection boxes
    cv2.putText(frame, f"Skin Type: {predicted_skin_type}", (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
    cv2.imshow('Skin Type Analyzer', frame)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
else:
    print("No objects detected.")

