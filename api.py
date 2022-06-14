import json
import os

from flask import Flask, jsonify, request, render_template
from flask_sqlalchemy import SQLAlchemy
import dotenv
from sqlalchemy import MetaData, create_engine
from sqlalchemy_utils import database_exists, create_database
from marshmallow import Schema, fields
from sqlalchemy.orm.attributes import InstrumentedAttribute


dotenv.load_dotenv()
db_user = os.environ.get('DB_USERNAME')
db_pass = os.environ.get('DB_PASSWORD')
db_hostname = os.environ.get('DB_HOSTNAME')
db_name = os.environ.get('DB_NAME')

DB_URI = 'mysql+pymysql://{db_username}:{db_password}@{db_host}/{database}'.format(db_username=db_user, db_password=db_pass, db_host=db_hostname, database=db_name)

# init the DB driver
engine = create_engine(DB_URI, echo=True)

# init Flask and SQLAlchemy
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = DB_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
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

        db.session.query(Student).filter(Student.id == self.id).update(updated_values)
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

def homemade_api_doc():
    descriptions = {
    }
    result = {}
    for i, map_object in enumerate(app.url_map.iter_rules()):  # app.url_map._rules
        rule = map_object.__getattribute__('rule')
        result[rule] = {}
        result[rule]['API_Endpoint'] = rule
        result[rule]['API_Endpoint_Name'] = map_object.__getattribute__('endpoint')
        #arguments = list(map_object.__getattribute__('arguments'))
        result[rule]['URL_Arguments'] = list(map_object.__getattribute__('arguments')) # {} if len(arguments) == 0 else arguments
        result[rule]['Accepted_Methods'] = list(map_object.__getattribute__('methods'))
    result['Example_Values'] = student_schema().load({'id':0, 'name':'Sample Name', 'email': 'some@email.com', 'cellphone':'123456789', 'age':111})
    schema_stripped = {}
    for akey, value in student_schema.__dict__['_declared_fields'].items():
        schema_stripped[akey] = str(value).split("(dump_default=")[0][1:]
    result['Declared_Schema'] = schema_stripped
    print(result)
    return jsonify(result), 200


@app.route('/api', methods = ['GET'])
def homemade_api_doc():
    # result = json.load(open('static/openapi.json'))
    # return jsonify(result), 200
    return render_template('swaggerui.html')


@app.route('/api/students', methods=['GET'])
def get_all_students():
    students = Student.get_all()
    student_list = student_schema(many=True)
    response = student_list.dump(students)
    return jsonify(response), 200

@app.route('/api/students/get/<int:id>', methods = ['GET'])
def get_student(id):
    student_info = Student.get_by_id(id)
    serializer = student_schema()
    response = serializer.dump(student_info)
    return jsonify(response), 200

@app.route('/api/students/modify/<int:id>', methods = ['PATCH'])
@app.route('/api/students/change/<int:id>', methods = ['PUT'])
def update_student(id):
    student_info = Student.get_by_id(id)
    json_data = request.get_json()
    student_info.update(json_data)
    serializer = student_schema()
    response = serializer.dump(student_info)
    return jsonify(response), 200

@app.route('/api/students/delete/<int:id>', methods = ['DELETE'])
def delete_student(id):
    student_info = Student.get_by_id(id)
    student_info.delete()
    return {}, 204

@app.route('/api/students/add', methods = ['POST'])
def add_student():
    json_data = request.get_json()
    new_student = Student(
        name= json_data.get('name'),
        email=json_data.get('email'),
        age=json_data.get('age'),
        cellphone=json_data.get('cellphone')
    )
    new_student.save()
    serializer = student_schema()
    data = serializer.dump(new_student)
    return jsonify(data), 201

if __name__ == "__main__":
    if not database_exists(engine.url):
        create_database(engine.url)
    db.create_all()
    app.run(host="0.0.0.0", debug=True)