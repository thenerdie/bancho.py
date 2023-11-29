# Python build stage
FROM python:3.11-slim AS python-build

ENV PYTHONUNBUFFERED=1

WORKDIR /srv/root

RUN apt update && apt install --no-install-recommends -y \
    git curl build-essential=12.9 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install -U pip setuptools
RUN pip install -r requirements.txt

# NOTE: done last to avoid re-run of previous steps
COPY . .

ARG PYTHON_VERSION=3.11
ENV PYTHON_VERSION=${PYTHON_VERSION}

FROM caddy:alpine

RUN apk add --no-cache bash python3

COPY --from=python-build /srv/root /srv/root
COPY --from=python-build /usr/local/lib/python${PYTHON_VERSION}/site-packages /usr/local/lib/python${PYTHON_VERSION}/site-packages

COPY ./Caddyfile /etc/caddy/Caddyfile

WORKDIR /srv/root

ENTRYPOINT [ "scripts/start_server.sh" ]
