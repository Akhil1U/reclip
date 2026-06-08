FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000
# Auto-update yt-dlp to latest on every deploy — critical for YouTube support
# since YouTube frequently changes its extraction logic.
CMD yt-dlp -U --quiet 2>/dev/null || true && \
    gunicorn --bind 0.0.0.0:8000 --workers 2 app:app

