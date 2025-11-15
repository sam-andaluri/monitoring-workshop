#!/usr/bin/env python3
from prometheus_client import start_http_server, Gauge
import time
import random

# TODO: Define a Gauge metric named 'app_active_sessions'
# with the description 'Number of active user sessions'
# Hint: use Gauge() from prometheus_client
# https://prometheus.github.io/client_python/instrumenting/gauge/
# app_active_sessions = Guage(name, description)


def collect_metrics():
    """Simulate collecting application metrics"""
    while True:
        # Simulate active sessions count (between 10 and 100)
        # In real life, this would be collected from the application
        active_sessions = random.randint(10, 100)

        # TODO: Set the gauge metric value to active_sessions
        # Hint: use the .set() method
        # app_active_sessions.set(variable_name)

        # This is the interval that this metrics will be updated. 
        # Wait 5 seconds before next collection
        time.sleep(5)


if __name__ == '__main__':
    # Start the HTTP server on port 8000
    # TODO: Start the prometheus metrics HTTP server on port 8000
    # Hint: use start_http_server(port)
    # ?

    # Start collecting metrics
    collect_metrics()
