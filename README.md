# Prometheus & Grafana Monitoring Workshop

A hands-on workshop for learning Prometheus and Grafana as it is deployed and used in our stack through practical exercises.

## Workshop Overview

This workshop consists of 6 progressive exercises that teach you how to build a complete monitoring solution using Prometheus and Grafana.

## Infrastructure Setup

As a pre-requisite you should have created a 2 node cluster using HPC 3.0.0 stack with 1 controller node, enabled monitoring in the stack without an additional monitoring node and 1 CPU compute node.

### Nodes:
- **Controller Node**: Runs Prometheus and Grafana
- **Worker Node**: Runs exporters (node_exporter and custom app_exporter)

### Prerequisites:
- Python 3.x installed on worker node
- `prometheus_client` Python package installed
- Prometheus installed and configured on controller node
- Grafana installed on controller node
- node_exporter running on worker node

## Exercises

### [Exercise 1: Create a Basic Prometheus Exporter](exercises/exercise1/)
**Objective**: Learn to create a custom Prometheus exporter using Python's `prometheus_client` library.

**Topics Covered**:
- Prometheus client library basics. Docs https://prometheus.github.io/client_python/
- Gauge metric type
- HTTP metrics endpoint
- Metric naming conventions

**Deliverable**: A working Python exporter exposing `app_active_sessions` metric

---

### [Exercise 2: Configure Systemd Service and Prometheus Service Discovery](exercises/exercise2/)
**Objective**: Deploy the exporter as a system service and configure Prometheus to scrape it.

**Topics Covered**:
- Systemd service unit files
- Service management with systemctl
- Prometheus file-based service discovery
- Configuration validation with promtool

**Deliverable**: Exporter running as a service, metrics visible in Prometheus

---

### [Exercise 3: Writing PromQL Queries](exercises/exercise3/)
**Objective**: Learn Prometheus Query Language (PromQL) to query and analyze metrics.

**Topics Covered**:
- Instant and range vectors
- Query functions (rate, avg_over_time, etc.)
- Metric arithmetic and transformations
- Querying both custom and node_exporter metrics

**Deliverable**: 5 working PromQL queries analyzing system and application metrics

---

### [Exercise 4: Prometheus Recording Rules](exercises/exercise4/)
**Objective**: Create recording rules to pre-compute expensive queries for better performance.

**Topics Covered**:
- Recording rule syntax and structure
- Rule naming conventions
- Rule validation and deployment
- Performance optimization strategies

**Deliverable**: 2 recording rules (1 for app metrics, 1 for node metrics)

---

### [Exercise 5: Manual Grafana Dashboard Creation](exercises/exercise5/)
**Objective**: Build a comprehensive monitoring dashboard in Grafana.

**Topics Covered**:
- Dashboard and panel creation
- Visualization types (Time Series, Stat, Gauge)
- Panel configuration and styling
- Thresholds and units
- Dashboard variables and templating

**Deliverable**: A complete monitoring dashboard with 4+ panels

---

### [Exercise 6: Advanced Topics](exercises/exercise6/)
**Objective**: Reserved for custom advanced content.

**Status**: Placeholder - to be completed based on specific needs

---

## Workshop Structure

Each exercise contains:

```
exercise<N>/
├── README.md           # Exercise instructions and learning objectives
├── starter/            # Incomplete files with TODOs for participants
│   └── ...
└── solution/           # Complete working solutions
    └── ...
```

## Getting Started

### 1. Fork repo (if you want to save your changes)

### 2. Clone (workshop or your forked repo) 

```bash
git clone <repository-url>
cd monitoring-workshop
```

### 2. Verify Prerequisites

**On Worker Node**:
```bash
# Check Python version
python3 --version

# Install prometheus_client
pip3 install prometheus_client

# Verify node_exporter is running
curl http://localhost:9100/metrics | head
```

**On Controller Node**:
```bash
# Check Prometheus
curl http://localhost:9090/-/healthy

# Check Grafana
curl http://localhost:3000/api/health

# Verify promtool
promtool --version
```

### 3. Start with Exercise 1

```bash
cd exercises/exercise1
cat README.md
```

Follow each exercise in order, as they build upon each other.

## Workshop Flow

```
Exercise 1: Write Exporter
     ↓
Exercise 2: Deploy & Configure
     ↓
Exercise 3: Query Metrics (PromQL)
     ↓
Exercise 4: Optimize with Recording Rules
     ↓
Exercise 5: Visualize in Grafana
     ↓
Exercise 6: Advanced Topics
```

## Validation Tools

Throughout the workshop, you'll use these tools to validate your work:

```bash
# Validate Prometheus config
promtool check config /etc/prometheus/prometheus.yml

# Validate recording rules
promtool check rules /path/to/rules.yml

# Validate service discovery file
promtool check sd-file /path/to/targets.json

# Query Prometheus


# Check systemd service status
systemctl status app-exporter.service

# View service logs
journalctl -u app-exporter.service -f
```

## Troubleshooting

### Common Issues:

**Exporter won't start**:
```bash
# Check logs
sudo journalctl -u app-exporter.service -n 50

# Verify Python script
python3 /path/to/app_exporter.py

# Check permissions
ls -la /opt/exporters/app_exporter/
```

**Prometheus not scraping target**:
```bash
# Check targets page
http://controller-node:9090/targets

# Verify network connectivity
curl http://worker-node:8000/metrics

## Resources

### Official Documentation:
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Python Client](https://github.com/prometheus/client_python)
- [PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)

### Community Resources:
- [Prometheus Best Practices](https://prometheus.io/docs/practices/)
- [Grafana Community Dashboards](https://grafana.com/grafana/dashboards/)
- [Node Exporter Full Dashboard](https://grafana.com/grafana/dashboards/1860)

## Contributing

If you find issues or have suggestions for improving this workshop, please open an issue or submit a pull request.

