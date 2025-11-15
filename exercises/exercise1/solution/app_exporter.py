#!/usr/bin/env python3
from prometheus_client import start_http_server, Gauge
import time
import random

# Define a Gauge metric named 'app_active_sessions'
# with the description 'Number of active user sessions'
app_active_sessions = Gauge('app_active_sessions', 'Number of active user sessions')


def collect_metrics():
    """Simulate collecting application metrics"""
    while True:
        # Simulate active sessions count (between 10 and 100)
        active_sessions = random.randint(10, 100)

        # Set the gauge metric value to active_sessions
        app_active_sessions.set(active_sessions)

        # Wait 5 seconds before next collection
        time.sleep(5)


if __name__ == '__main__':
    # Start the HTTP server on port 8000
    start_http_server(8000)

    # Start collecting metrics
    collect_metrics()
