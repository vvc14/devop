FROM python:3.11-slim

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["uvicorn","main:app","--port","5000","--host","0.0.0.0"]
