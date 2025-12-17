#FROM alpine:3.23.0
FROM python:3.11-slim-bookworm

# RUN apk update && apk add python3 && apk add py3-pip \
#     && apk add --no-cache \
#     mesa-gl libx11 libxext libxrender libxrandr libxi libxcursor libxinerama
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb xauth x11-utils \
    libgl1 \
    libglu1-mesa \
    libx11-6 libxext6 libxi6 libxrender1 libxrandr2 \
    libxcursor1 libxinerama1 libxxf86vm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR app

COPY . .

RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install -r requirements.txt

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 80

# ENTRYPOINT ["python3", "main.py"]
ENTRYPOINT ["xvfb-run", "-a", "-s", "-screen 0 1280x720x24", "python3", "main.py"]

CMD []