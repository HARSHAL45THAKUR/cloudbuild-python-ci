# Use official Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install dependencies from requirements.txt
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the port Gunicorn will run on
EXPOSE 8080

# Run using Gunicorn for production
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
