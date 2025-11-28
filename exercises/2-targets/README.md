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

**File-based Service Discovery** allows Prometheus to dynamically discover targets by reading JSON or YAML files. This is useful when targets change frequently such as our customer clusters.

## Task

### 1. On the Worker Node - Implement the following steps.

#### Systemd Service for the Exporter

1. Complete the `starter/app-exporter.service` file by:
   1. Locate the venv python3 for oci venv (e.g. /config/venv/Ubuntu_22.04_x86_64/oci/)  
   2. Set the `ExecStart` command to run the Python exporter script using venv python3. 

2. Copy the python script to `/usr/local/bin` (sudo required)

3. Copy the service file:
   ```bash
   sudo cp starter/app-exporter.service /etc/systemd/system/
   ```

4. Enable and start the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable app-exporter.service
   sudo systemctl start app-exporter.service
   ```

5. Check service status (should be in running state):
   ```bash
   sudo systemctl status app-exporter.service
   ```

6. Verify the exporter is running:
   ```bash
   curl http://localhost:8000/metrics | grep app_active_sessions
   ```

### 2. On the Controller/Monitoring node - Implement the following steps.

#### Configure Prometheus File-Based Service Discovery

1. Find the existing target file for the compute node in `/etc/prometheus/targets` 
Adding a new target configuration for the app_exporter

> The following are examples only. Substitute appropriate hostnames. The solution filel for targets is also an example. *DO NOT USE worker-node.json as is.* Modify the existing target in /etc/prometheus/targets as per workshop instructions 

2. Edit /etc/prometheus/targets/worker-node.json (replace worker-node with your worker node hostname)

3. Add the new target to /etc/prometheus/targets/worker-node.json (replace worker-node with your worker node hostname). sudo required to edit the file.

4. Validate json file using jq. You should not see any errors and your new target listed in the output:
   ```bash
   jq . /etc/prometheus/targets/worker-node.json
   ```

5. Validate Prometheus configuration using promtool. Should report SUCCESS:
   ```bash
   promtool check config /etc/prometheus/prometheus.yml
   ```

6. Query Prometheus to ensure that metrics are being scraped. 
   ```bash
   promtool query instant http://localhost:9090 'app_active_sessions'
   promtool query range http://localhost:9090 'app_active_sessions'
   ```

## Expected Output

- Systemd service should be running without errors
- Query for `app_active_sessions` should return data

## Troubleshooting

- **Service won't start**: Check logs with `sudo journalctl -u app-exporter.service -f`

## Learning Points
- Systemd service configuration for Python applications
- File-based service discovery in Prometheus
- Using promtool for configuration validation
- Service management with systemctl
