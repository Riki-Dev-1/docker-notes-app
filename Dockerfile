# Stage 1: Builder stage
FROM python:3.9-alpine AS builder

# Set working directory
WORKDIR /app

# Copy the requirements.txt and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final stage
FROM python:3.9-alpine

# Set environment variables
ENV NOTES_FILE=/data/notes.json
ENV APP_NAME="Docker Notes App"

# Set working directory
WORKDIR /app

# Copy only necessary files from builder stage
COPY --from=builder /app /app

# Create empty notes file if it doesn't exist
RUN mkdir -p /data

# Expose the port
EXPOSE 5000

# Copy app files
COPY app.py .

# Copy templates folder
COPY templates ./templates

# Health check to verify the app is running
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost:5000 || exit 1

# Run the Flask app
CMD ["python", "app.py"]

