from dotenv import load_dotenv

load_dotenv()

from flask import Flask, g, jsonify, request
from middleware import auth
from repository import task as task_repository

app = Flask(__name__)


@app.get("/health")
def health_check_route():
    return jsonify(message="Service healthy!"), 200


@app.post("/tasks")
@auth
def create_task_route():
    if request.is_json:
        user = getattr(g, "user", None)

        if user is None:
            return jsonify(message="Auth didn't provided an user"), 404

        data = request.get_json()

        to_do_task = data.get("task")

        if to_do_task is None or type(to_do_task) != str:
            return jsonify(message="No user_name provided"), 400

        task_repository.create_task(user_id=user.id, task=to_do_task)

        return jsonify(message="Task created with success"), 201

    else:
        return jsonify(message="The request body must be a json"), 400


@app.get("/tasks")
@auth
def get_all_tasks_routes():
    user = getattr(g, "user", None)

    if user is None:
        return jsonify(message="Auth didn't provided user"), 404

    tasks = task_repository.get_all(user.id)

    return (
        jsonify(
            tasks=[
                {"id": task.id, "text": task.text, "status": task.status}
                for task in tasks
            ]
        ),
        200,
    )


@app.put("/taks")
@auth
def update_task_route():
    if request.is_json:
        user = getattr(g, "user", None)

        if user is None:
            return jsonify(message="Auth didn't provided user"), 404

        data = request.get_json()

        task_id = data.get("task_id")
        new_task_status = data.get("status")

        if new_task_status not in ["pending", "done"] or task_id is None:
            return jsonify(message="Uncompleted body"), 400

        task = task_repository.update_task(user.id, task_id, new_task_status)

        if task is None:
            return jsonify(message="Unable to update task"), 500

        return jsonify(message="Task modified with success"), 202

    else:
        return jsonify(message="The request body must be a json"), 400


@app.delete("/tasks")
@auth
def delete_task_route():
    if request.is_json:
        user = getattr(g, "user", None)

        if user is None:
            return jsonify(message="Auth didn't provided an user"), 404

        data = request.get_json()

        task_id = data.get("task_id")

        if task_id is None:
            return jsonify(message="Uncompleted body"), 400

        task = task_repository.delete_task(user.id, task_id)

        if task is None:
            return jsonify(message="Task doesn't exists"), 500

        return jsonify(message="Task deleted with success"), 203

    else:
        return jsonify(message="The request body must be a json"), 400


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3003)
