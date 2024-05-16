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
@admin_auth
def create_user_route():
    if request.is_json:
        data = request.get_json()

        user_name = data.get("user_name")
        user_role = data.get("user_role")

        if (
            user_name is None
            or type(user_name) != str
            or user_role not in ["admin", "user"]
        ):
            return jsonify(message="Uncompleted body"), 400

        user_repository.create_user(user_name=user_name, user_role=user_role)

        return jsonify(message="User created with success!"), 201
    else:
        return jsonify(message="The request body must be a json"), 400


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3002)
