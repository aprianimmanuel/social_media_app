# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV PATH="/py/bin:$PATH"

# Set the working directory to /app/
WORKDIR /app/

# Copy requirements.txt into the container at /app/
COPY requirements.txt /app/

# Install required packages and clean up
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r requirements.txt && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /tmp/* /var/tmp/*

# Copy the current directory contents into the container at /app/
COPY . /app/

# Create a non-root user
RUN adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Change to the non-root user
USER django-user

# Expose port 8000
EXPOSE 8000

# Command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
