FROM python:3.12

RUN mkdir /app
WORKDIR /app

COPY requirements.lock .
RUN sed '/-e/d' requirements.lock > requirements.txt && pip install -r requirements.txt

COPY . .

RUN useradd app
USER app

CMD gunicorn config.wsgi --bind=0.0.0.0:8000 --workers=4 --threads=4 --max-requests=500 --max-requests-jitter=200
EXPOSE 8000

