FROM python:3.8-alpine
RUN mkdir /app
ADD gdrive-push-job /app
WORKDIR /app
RUN pip install pydrive
CMD ["python", "gdrive-upload.py"]