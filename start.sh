#!/bin/bash
set -e

# Start Xvfb
Xvfb :99 -screen 0 1920x1200x24 -ac +extension GLX +render -noreset &
export DISPLAY=:99

# Start a window manager (required for some apps)
fluxbox &

# Start x11vnc
x11vnc -display :99 -nopw -listen localhost -xkb -forever -shared -rfbport 5900 &

# Start noVNC websockify
/opt/novnc/utils/websockify/run --web=/opt/novnc 6080 localhost:5900 &

# Wait a bit for services to start
sleep 2

# Start the application with all arguments
exec python3 main.py "$@"

