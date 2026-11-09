from fastapi import FastAPI,HTTPException
from pydantic import BaseModel,EmailStr
import uvicorn

class Student(BaseModel):
    name:str
    rollno:str
    email:EmailStr

students = {}
next_id = 1
app = FastAPI()
@app.get("/students")
def all_stu():
    return list(students.values())
@app.get("/students/{sid}")
def get_stu(sid:int):
    if sid not in students: return HTTPException(404,"Student Not Found")
    return students[sid]
@app.post("/students",status_code=201)
def post_stu(data:Student):
    global next_id
    student = {"id":next_id,**data.model_dump()}
    students[next_id] = student
    next_id+=1
    return student

@app.put("/students/{sid}")
def put_stu(sid:int,data:Student):
    if sid not in students:
        return HTTPException(404,"Student Not Found")
    students[sid].update(data.model_dump())
    return students[sid]

@app.delete("/students/{sid}")
def del_stu(sid:int):
    if sid not in students:
        return HTTPException(404,"Student Not Found")
    del students[sid]
    return {"message":f"deleted {sid} from students"}

if __name__=="__main__":
    uvicorn.run(app=app,port=5000,host="0.0.0.0")