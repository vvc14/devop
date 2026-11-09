from fastapi import FastAPI,HTTPException
from pydantic import BaseModel,EmailStr
import uvicorn

students = {}
next_id = 1
class Student(BaseModel):
    name:str
    rollno:str
    email:EmailStr

app = FastAPI()

@app.post("/students",status_code=201)
def post_stu(data:Student):
    global next_id
    student = {"id":next_id,**data.model_dump()}
    students[next_id] = student
    next_id+=1
    return student

@app.get("/students")
def all_stud():
    return list(students.values())

@app.get("/students/{sid}")
def get_stu(sid:int):
    if sid not in students:
        raise HTTPException(404,"Student Not Found")
    return students[sid]

@app.put("/students/{sid}")
def upd_stu(sid:int,data:Student):
    if sid not in students:
        raise HTTPException(404,"Student Not Found")
    students[sid].update(data.model_dump())
    return students[sid]

@app.delete("/students/{sid}", status_code=204)
def delete_student(sid: int):
    if sid not in students:
        raise HTTPException(404, "Student not found")

    del students[sid]

if __name__=="__main__":
    uvicorn.run(app=app,host="0.0.0.0",port=5000)
    
        