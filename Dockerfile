#FROM alpine:3.23.0
FROM python:3.11-slim-bookworm

# RUN apk update && apk add python3 && apk add py3-pip \
#     && apk add --no-cache \
#     mesa-gl libx11 libxext libxrender libxrandr libxi libxcursor libxinerama
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb xauth x11-utils \
    x11vnc \
    fluxbox \
    wget \
    libgl1 \
    libglu1-mesa \
    libx11-6 libxext6 libxi6 libxrender1 libxrandr2 \
    libxcursor1 libxinerama1 libxxf86vm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN mkdir -p /opt/novnc/utils && \
    wget -qO- https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar xz --strip 1 -C /opt/novnc && \
    wget -qO- https://github.com/novnc/websockify/archive/v0.11.1.tar.gz | tar xz --strip 1 -C /opt/novnc/utils/websockify

WORKDIR app

COPY . .

RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install -r requirements.txt

# Install websockify dependencies for noVNC
RUN pip3 install --no-cache-dir websockify

ENV PATH="/opt/venv/bin:$PATH"
ENV DISPLAY=:99

# Create cache directories
RUN mkdir -p .fastf1-cache computed_data

# Copy and set up startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 6080

ENTRYPOINT ["/start.sh"]
CMD []