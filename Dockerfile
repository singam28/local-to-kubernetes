FROM python:3.13
WORKDIR /code

# Install the application dependencies
COPY requirements.txt .
RUN pip install -r ./requirements.txt

COPY server.py .

CMD ["python", "./server.py"]