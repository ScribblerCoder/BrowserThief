FROM python:3.10.1

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install dependencies
RUN pip install Flask 
RUN pip install pycryptodomex==3.10.1

# Setup app
RUN mkdir -p /app

# Switch working environment
WORKDIR /app

# Add application
COPY src .

# Expose port the server is reachable on
EXPOSE 1337

# start app
ENTRYPOINT ["python", "run.py"]
