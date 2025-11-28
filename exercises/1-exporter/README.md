# Exercise 1: Create a Basic Prometheus Exporter

## Objective
Learn how to create a custom Prometheus exporter using the `prometheus_client` library and expose a gauge metric.

## Prerequisites (should be already installed)
- Python 3.x installed
- `prometheus_client` package installed (`pip install prometheus_client`)

## Background
Prometheus exporters are programs that expose metrics in a format that Prometheus can scrape. The `prometheus_client` library provides easy-to-use abstractions for creating exporters in Python.

A **Gauge** is a metric type that represents a value that can go up or down (e.g., temperature, memory usage, active sessions).

## Task
Complete the `starter/app_exporter.py` file by:

1. Defining a Gauge metric named `app_active_sessions` with the description "Number of active user sessions"
2. Setting the gauge value in the `collect_metrics()` function
3. Starting the HTTP server on port 8000

Look for `TODO` comments in the starter code.

## Testing Your Solution

1. Run the exporter (source the venv since default packages in latest 3.0.0 are only installed in oci env):

   ```bash   
   source /config/venv/Ubuntu_22.04_x86_64/oci/bin/activate
   cd monitoring-workshop/exercises/1-exporter/starter
   python3 app_exporter.py
   ```

2. In another terminal, check the metrics endpoint:
   ```bash
   curl http://localhost:8000/metrics | grep app_active_sessions
   ```

3. You should see output similar to:
   ```
   # HELP app_active_sessions Number of active user sessions
   # TYPE app_active_sessions gauge
   app_active_sessions 45.0
   ```

4. Ctrl-C from the session where app_exporter.py is running in the terminal to free up the port and to proceed to next exercise.

## Expected Output
- The `/metrics` endpoint should expose the `app_active_sessions` metric
- The metric value should update every 5 seconds with a random value between 10 and 100

## Learning Points
- How to use the `prometheus_client` library
- Understanding Gauge metrics
- Exposing metrics via HTTP endpoint
- Metric naming conventions [snake_case](https://www.freecodecamp.org/news/snake-case-vs-camel-case-vs-pascal-case-vs-kebab-case-whats-the-difference/
).



