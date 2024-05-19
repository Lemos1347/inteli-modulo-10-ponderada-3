from dotenv import load_dotenv

load_dotenv()

from flask import Flask, jsonify, request
from middleware import admin_auth, auth
from repository import user as user_repository

app = Flask(__name__)


@app.get("/health")
def health_check_route():
    return jsonify(message="Service healthy!"), 200


@app.post("/users")
# @admin_auth
def create_user_route():
    if request.is_json:
        data = request.get_json()

        user_name = data.get("name")
        user_email = data.get("email")
        user_password = data.get("password")

        if (
            type(user_name) != str
            or type(user_email) != str
            or type(user_password) != str
        ):
            return jsonify(message="Uncompleted body"), 400

        user_repository.create_user(
            user_name=user_name, user_email=user_email, user_password=user_password
        )

        return jsonify(message="User created with success!"), 200
    else:
        return jsonify(message="The request body must be a json"), 400


@app.post("/users/login")
def login_user_route():
    if request.is_json:
        data = request.get_json()

        user_email = data.get("email")
        user_password = data.get("password")

        if type(user_email) != str or type(user_password) != str:
            return jsonify(message="Uncompleted body"), 400

        if user_repository.login_user(
            user_email=user_email, user_password=user_password
        ):
            return jsonify(message="User loged in with success!"), 200

        return jsonify(message="Not allowed!"), 401
    else:
        return jsonify(message="The request body must be a json"), 400


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3002)
