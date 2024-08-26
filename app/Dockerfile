FROM python:3.12

RUN mkdir /app
WORKDIR /app

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.7.0 /lambda-adapter /opt/extensions/lambda-adapter

COPY requirements.lock .
RUN sed '/-e/d' requirements.lock > requirements.txt && pip install -r requirements.txt
ENV DJANGO_SETTINGS_MODULE=config.settings.production

COPY . .

CMD python manage.py migrate && \
    gunicorn config.wsgi --bind=0.0.0.0:8080 --workers=1 --threads=1 --max-requests=500
EXPOSE 8080

