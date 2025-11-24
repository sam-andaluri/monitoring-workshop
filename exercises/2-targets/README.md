# Exercise 2: Configure Systemd Service and Prometheus File-Based Service Discovery

## Objective
Learn how to:
1. Create a systemd service unit file for the custom exporter
2. Configure Prometheus file-based service discovery
3. Validate metrics using promtool

## Prerequisites
- Completed Exercise 1
- Access to worker node with sudo privileges
- Prometheus already installed on controller node

## Background

**Systemd** is the init system used by most modern Linux distributions. Service unit files define how systemd should manage services (start, stop, restart, etc.).

**File-based Service Discovery** allows Prometheus to dynamically discover targets by reading JSON or YAML files. This is useful when targets change frequently or when integrating with external configuration management systems.

## Task

### Part 1: Create Systemd Service Unit File

Complete the `starter/app-exporter.service` file by:
1. Locate the venv python3 for oci venv (e.g. /config/venv/Ubuntu_22.04_x86_64/oci/)  
2. Copy the python script to `/usr/local/bin`
3. Set the `ExecStart` command to run the Python exporter script using venv python3. 

### Part 2: Configure Prometheus File-Based Service Discovery

1. Find the existing target file for the compute node in `/etc/prometheus/targets` 
Adding a new target configuration for the app_exporter
2. The exporter runs on `worker-node:8000` Dont forget to change worker-node to your worker node hostname name.
3. Add the new exporter to appropriate target file.

## Deployment Steps

### On Worker Node:

1. Copy the service file:
   ```bash
   sudo cp starter/app-exporter.service /etc/systemd/system/
   ```

2. Enable and start the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable app-exporter.service
   sudo systemctl start app-exporter.service
   ```

3. Check service status:
   ```bash
   sudo systemctl status app-exporter.service
   ```

4. Verify the exporter is running:
   ```bash
   curl http://localhost:8000/metrics | grep app_active_sessions
   ```

### On Controller Node:

The following are examples only. 

1. Edit /etc/prometheus/targets/worker-node.json (replace worker-node with your worker node hostname)

2. Add the new target to /etc/prometheus/targets/worker-node.json (replace worker-node with your worker node hostname)

3. Validate json file using jq:
   ```bash
   jq . /etc/prometheus/targets/worker-node.json
   ```

4. Validate Prometheus configuration using promtool:
   ```bash
   promtool check config /etc/prometheus/prometheus.yml
   ```

5. Validate the service discovery file:
   ```bash
   promtool check sd-file /etc/prometheus/targets/worker-node.json
   ```

6. **Query Prometheus**: Test that metrics are being scraped. Replace controller-node with your controller node hostname.
   ```bash
   curl 'http://controller-node:9090/api/v1/query?query=app_active_sessions' | jq
   ```

## Expected Output

- Systemd service should be running without errors
- `promtool check sd-file` should return SUCCESS
- Query for `app_active_sessions` should return data

## Troubleshooting

- **Service won't start**: Check logs with `sudo journalctl -u app-exporter.service -f`

## Learning Points
- Systemd service configuration for Python applications
- File-based service discovery in Prometheus
- Using promtool for configuration validation
- Service management with systemctl
