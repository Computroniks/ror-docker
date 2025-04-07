FROM python:3.8 AS builder

RUN mkdir /app
WORKDIR /app

# Set environment variables 
# Prevents Python from writing pyc files to disk
ENV PYTHONDONTWRITEBYTECODE=1
#Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1 

# Upgrade pip
RUN pip install --upgrade pip 

# Needed for custom requirement
RUN apt-get install git

COPY ror-api/requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn


FROM python:3.8-slim

RUN useradd -m -r appuser && \
   mkdir /app && \
   chown -R appuser /app

# Copy the Python dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.8/site-packages/ /usr/local/lib/python3.8/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

# Set the working directory
WORKDIR /app
 
# Copy application code
COPY --chown=appuser:appuser ./ror-api/. .
COPY --chown=appuser:appuser ./ror-setup-override.py ./rorapi/management/commands/setup.py

RUN apt-get update && apt-get install -y --no-install-recommends libmagic1 && rm -rf /var/lib/apt/lists/*
 
# Set environment variables to optimize Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1 

RUN python manage.py collectstatic --noinput
 
# Switch to non-root user
USER appuser
 
# Expose the application port
EXPOSE 8000 
 
# Start the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "rorapi.wsgi:application"]
