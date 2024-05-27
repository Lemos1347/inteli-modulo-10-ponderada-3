from dotenv import load_dotenv

load_dotenv()

import os

from flask import Flask, g, jsonify, request, send_from_directory
from PIL import Image
from werkzeug.utils import secure_filename

from middleware import admin_auth, auth
from repository import user as user_repository

app = Flask(__name__)

UPLOAD_FOLDER = "./temp/uploads"
PROCESSED_FOLDER = "./temp/processed"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["PROCESSED_FOLDER"] = PROCESSED_FOLDER

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(PROCESSED_FOLDER, exist_ok=True)


@app.get("/health")
def health_check_route():
    return jsonify(message="Service healthy!"), 200


@app.post("/images")
@auth
def process_image_route():
    if "file" not in request.files:
        print("no file")
        return "No file part", 404
    file = request.files["file"]
    if file.filename == "":
        print("sem nome")
        return "No selected file"
    if file:
        print("existe")
        filename = secure_filename(file.filename)
        print(filename)
        filepath = os.path.join(app.config["UPLOAD_FOLDER"], str(g.user.id))
        os.makedirs(filepath, exist_ok=True)
        filepath = os.path.join(filepath, filename)
        file.save(filepath)

        # Abre a imagem
        img = Image.open(filepath)
        # Converte para preto e branco
        img = img.convert("L")
        # Salva a imagem processada
        os.makedirs(
            os.path.join(app.config["PROCESSED_FOLDER"], str(g.user.id)), exist_ok=True
        )
        processed_path = os.path.join(
            app.config["PROCESSED_FOLDER"], str(g.user.id), filename
        )
        img.save(processed_path)

        return jsonify("File successfully uploaded and processed"), 200

    return jsonify("No image provided"), 404


@app.get("/images")
@auth
def get_images_route():
    folder = request.args.get("folder", "uploaded")

    if folder == "uploaded":
        directory = app.config["UPLOAD_FOLDER"]
    elif folder == "processed":
        directory = app.config["PROCESSED_FOLDER"]
    else:
        return "Invalid folder specified", 400

    directory = os.path.join(directory, str(g.user.id))
    files = os.listdir(directory)
    files = [f for f in files if os.path.isfile(os.path.join(directory, f))]

    return jsonify(files)


@app.get("/image")
@auth
def get_image_route():
    filename = request.args.get("filename")
    folder = request.args.get("folder", "uploaded")

    if not filename:
        return "Filename is required", 400

    if folder == "uploaded":
        directory = app.config["UPLOAD_FOLDER"]
    elif folder == "processed":
        directory = app.config["PROCESSED_FOLDER"]
    else:
        return "Invalid folder specified", 400

    directory = os.path.join(directory, str(g.user.id))

    print(directory)
    print(os.path.join(directory, filename))

    if not os.path.isfile(os.path.join(directory, filename)):
        return "File not found", 404

    return send_from_directory(directory, filename)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3003)
