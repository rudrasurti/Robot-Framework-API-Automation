FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY resources ./resources
COPY schemas ./schemas
COPY tests ./tests

CMD ["pabot", "--processes", "4", "--outputdir", "results", "tests/"]
