from fastapi import FastAPI,Response,Request
from prometheus_client import Histogram,Counter,generate_latest,CONTENT_TYPE_LATEST
import time
import uvicorn

app = FastAPI()
REQUESTS = Counter("api_requests_total","Total API Requests",["method","endpoint","status"])
LATENCY = Histogram("api_requests_duration_seconds","API Request Duration Seconds",["endpoint"])
@app.get("/")
async def home():
    return {"Message":"hello"}

@app.middleware("http")
async def middleware(request:Request,call_next):
    start_time = time.perf_counter()
    response = await call_next(request)
    if request.url.path!="/metrics":
        duration = time.perf_counter()-start_time
        LATENCY.labels(endpoint=request.url.path).observe(duration)
        REQUESTS.labels(method=request.method,endpoint=request.url.path,status=response.status_code).inc()
    return response

@app.get("/metrics")
def get_metrics():
    return Response(content=generate_latest(),media_type=CONTENT_TYPE_LATEST)
if __name__=="__main__":
    uvicorn.run(app=app,port=5000,host="0.0.0.0")
        
        
        
         