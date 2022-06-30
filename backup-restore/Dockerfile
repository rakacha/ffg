FROM python:3.8-alpine
RUN mkdir /app
ADD gdrive-sync-job /app
WORKDIR /app
RUN pip install pydrive
CMD ["python", "gdrive_sync.py"]
