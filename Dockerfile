# Caddy stage with Python and required packages
FROM caddy:alpine

WORKDIR /srv/root

# Install bash, Python, pip, and other necessary packages
RUN apk add --no-cache bash python3 py3-pip \
    && apk add --no-cache git curl build-base

# Copy the Python requirements and install them
COPY requirements.txt ./
RUN pip install -U pip setuptools
RUN pip install -r requirements.txt

# Copy your application code
COPY . .

# Copy the Caddyfile
COPY ./Caddyfile /etc/caddy/Caddyfile

# Set the entry point to start the server
ENTRYPOINT [ "bash", "scripts/start_server.sh" ]
