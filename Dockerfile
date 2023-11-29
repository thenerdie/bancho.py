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

FROM caddy:alpine

COPY --from=python-build /srv/root /srv/root

COPY ./Caddyfile /etc/caddy/Caddyfile

WORKDIR /srv/root

ENTRYPOINT [ "scripts/start_server.sh" ]
