import json
import os
import inspect

from flask import Flask, jsonify, request, render_template
from flask_sqlalchemy import SQLAlchemy
import dotenv
from sqlalchemy import create_engine
from sqlalchemy_utils import database_exists, create_database
from marshmallow import Schema, fields
from sqlalchemy.orm.attributes import InstrumentedAttribute


dotenv.load_dotenv()
db_user = os.environ.get("MYSQL_USER")
db_pass = os.environ.get("MYSQL_PASSWORD")
db_hostname = os.environ.get("DB_HOSTNAME")
db_name = os.environ.get("MYSQL_DATABASE")

DB_URI = "mysql+pymysql://{db_username}:{db_password}@{db_host}/{database}"\
         .format(db_username=db_user, db_password=db_pass,
                 db_host=db_hostname, database=db_name)

# init the DB driver
engine = create_engine(DB_URI, echo=True)

# init Flask and SQLAlchemy
app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = DB_URI
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)


# SQLAlchemy ORM object
class Student(db.Model):
    __tablename__ = "student"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    age = db.Column(db.Integer, nullable=False)
    cellphone = db.Column(db.String(13), unique=True, nullable=False)

    @classmethod
    def get_all(cls):
        return cls.query.all()

    @classmethod
    def get_by_id(cls, id):
        return cls.query.get_or_404(id)

    def update(self, json_data):
        updated_values = {}
        for akey, value in Student.__dict__.items():
            if isinstance(value, InstrumentedAttribute):
                updated_values[akey] = getattr(self, akey)
        updated_values.update(json_data)

        db.session.query(Student).filter(Student.id == self.id)\
                                 .update(updated_values)
        db.session.commit()

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()


# init marshmallow object
class StudentSchema(Schema):
    id = fields.Integer(required=True)
    name = fields.Str()
    email = fields.Str()
    age = fields.Integer()
    cellphone = fields.Str()


student_schema = StudentSchema


@app.route("/api", methods=["GET"])
def generate_swagger_api_doc():
    return_code = 200
    result = json.load(open("static/openapi.json"))
    result["paths"] = {}
    result["servers"][0]["url"] = "http://" + request.headers.get("Host") + "/"
    source_code = {}
    data_body = [
        {
            "in": "body",
            "name": "body",
            "description": "Student object",
            "required": True,
            "schema": {"$ref": "#/definitions/Student"},
        }
    ]
    student_id = {
        "name": "id",
        "in": "path",
        "description": "ID of the Student",
        "required": True,
        "type": "integer",
    }
    # "put"/"patch" need: student_id + data_body
    # "get"/"delete" need: student_id
    # "add" - only data_body
    for i, map_object in enumerate(app.url_map.iter_rules()):
        rule = map_object.__getattribute__("rule")
        if "/static" in rule:
            continue
        rule = rule if "<int:id>" not in rule else rule.replace(
           "<int:id>", "{id}")
        method = list(
            set(map_object.__getattribute__("methods"))
            - set(["OPTIONS", "HEAD"])
        )[0].lower()
        operationId = map_object.__getattribute__("endpoint")
        source_code[rule] = "".join(inspect.
                                    getsource(eval(operationId))).replace(
                                    "\n", " ")
        status_code = source_code[rule].split(
                      "return_code = ")[1].split(" ")[0]
        parameters = list(map_object.__getattribute__("arguments"))
        parameters = (
            parameters[0] if len(parameters) > 0 else []
        )  # we know that only 'id' is present in the path
        result["paths"][rule] = {
            method: {
                "tags": ["student"],
                "produces": ["application/json"],
                "responses": {
                  status_code: {"description":
                                "the operation was successful"}
                },
            }
        }
        if "change" in rule or "modify" in rule:
            result["paths"][rule][method]["parameters"] = data_body[:]
            result["paths"][rule][method]["parameters"].append(student_id)
        elif "add" in rule:
            result["paths"][rule][method]["parameters"] = data_body[:]
        elif "delete" in rule or "get" in rule:
            result["paths"][rule][method]["parameters"] = [student_id]
    json.dump(result, open("static/openapi.json", "w"))
    return render_template("swaggerui.html"), return_code


@app.route("/api/health-check/ok", methods=["GET"])
def health_check_ok():
    return_code = 200
    return {}, return_code


@app.route("/api/health-check/bad", methods=["GET"])
def health_check_bad():
    return_code = 500
    return {}, return_code


@app.route("/api/students", methods=["GET"])
def get_all_students():
    return_code = 200
    students = Student.get_all()
    student_list = student_schema(many=True)
    response = student_list.dump(students)
    return jsonify(response), return_code


@app.route("/api/students/get/<int:id>", methods=["GET"])
def get_student(id):
    return_code = 200
    student_info = Student.get_by_id(id)
    serializer = student_schema()
    response = serializer.dump(student_info)
    return jsonify(response), return_code


@app.route("/api/students/change/<int:id>", methods=["PUT"])
@app.route("/api/students/modify/<int:id>", methods=["PATCH"])
def update_student(id):
    return_code = 200
    student_info = Student.get_by_id(id)
    json_data = request.get_json()
    student_info.update(json_data)
    serializer = student_schema()
    response = serializer.dump(student_info)
    return jsonify(response), return_code


@app.route("/api/students/delete/<int:id>", methods=["DELETE"])
def delete_student(id):
    return_code = 204
    student_info = Student.get_by_id(id)
    student_info.delete()
    return {}, return_code


@app.route("/api/students/add", methods=["POST"])
def add_student():
    return_code = 201
    json_data = request.get_json()
    new_student = Student(
        name=json_data.get("name"),
        email=json_data.get("email"),
        age=json_data.get("age"),
        cellphone=json_data.get("cellphone"),
    )
    new_student.save()
    serializer = student_schema()
    data = serializer.dump(new_student)
    return jsonify(data), return_code


if not database_exists(engine.url):
    create_database(engine.url)
db.create_all()

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
