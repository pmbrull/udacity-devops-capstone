FROM python:3.7.3-stretch

# Create a working directory
WORKDIR /app

# Copy source code to working directory
COPY . app.py /app/

# Install packages from requirements.txt
# hadolint ignore=DL3013
RUN pip install --upgrade pip &&\
    pip install --trusted-host pypi.python.org -r requirements.txt

# Set a default port
ARG APP_PORT=5000

# Expose port variable
EXPOSE $APP_PORT

# Run app.py at container launch
CMD ["python", "app.py"]