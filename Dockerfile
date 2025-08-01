# --- STAGE 1: The "Builder" Stage ---
# Instructions are in ALL CAPS.
# The 'as builder' part names this stage. This is critical.
FROM python:3.9-slim AS builder

WORKDIR /app

# Copying requirements first for cache optimization.
COPY requirements.txt .

RUN pip install --no-cache-dir --prefix="/install" -r requirements.txt


# --- STAGE 2: The "Final" Stage ---
# This FROM instruction starts a new, completely clean stage.
FROM python:3.9-alpine

WORKDIR /app

# The --from=builder flag is the key to the multi-stage build.
# It tells Docker to copy from the stage we named 'builder'.
COPY --from=builder /install /usr/local

# Copy the application code last.
COPY app.py .

ENV PYTHONPATH=/lib/python3.9/site-packages

EXPOSE 5000

CMD ["/bin/python", "app.py"]
