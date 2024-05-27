from functools import wraps

import jwt
from flask import g, jsonify, request
from repository import user as user_repository

SECRET_KEY = 'secret'

def auth(f):
    @wraps(f)
    def auth_function(*args, **kwargs):
        try:
            auth_header = request.headers.get("Authorization")

            if auth_header is None:
                raise KeyError("No auth provided")

            # O header deve ter o formato "Bearer token"
            parts = auth_header.split()

            if len(parts) != 2 or parts[0].lower() != 'bearer':
                raise KeyError("Invalid auth header format")

            token = parts[1]

            # Decodificar o token
            payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])

            user_id = payload.get('user_id')
            if user_id is None:
                raise KeyError("Token invalid: no user_id found")

            user = user_repository.get_user_by_id(user_id)

            if user is None or user.role not in ["user", "admin"]:
                raise KeyError("User not authorized")

            g.user = user
            return f(*args, **kwargs)

        except jwt.ExpiredSignatureError:
            return jsonify({"message": "Token expired"}), 401
        except jwt.InvalidTokenError:
            return jsonify({"message": "Invalid token"}), 401
        except Exception as err:
            return jsonify({"message": f"{err}"}), 401

    return auth_function


def admin_auth(f):
    @wraps(f)
    def admin_auth_function(*args, **kwargs):
        try:
            print("veio")
            user_id = request.headers.get("Authorization")

            print(user_id)

            if user_id is None:
                raise KeyError("No auth provided")

            user = user_repository.get_user_by_id(user_id)

            if user is None or user.role not in ["admin"]:
                raise KeyError("User not authorized")

            g.user = user

            print("peguei")
            return f(*args, **kwargs)

        except Exception as err:
            return jsonify({"message": f"{err}"}), 401

    return admin_auth_function
