# Quick Reference Guide

## Common Commands

### Prometheus

```bash
# Check Prometheus config
promtool check config /etc/prometheus/prometheus.yml

# Validate recording rules
promtool check rules /etc/prometheus/rules/*.yml

# Validate service discovery file
promtool check sd-file /etc/prometheus/file_sd/targets.json

# Query Prometheus API
curl 'http://localhost:9090/api/v1/query?query=up'

# Query with time range
curl -G 'http://localhost:9090/api/v1/query_range' \
  --data-urlencode 'query=app_active_sessions' \
  --data-urlencode 'start='$(date -u -d '1 hour ago' +%s) \
  --data-urlencode 'end='$(date -u +%s) \
  --data-urlencode 'step=15s'

# Reload Prometheus configuration
sudo systemctl reload prometheus

# Restart Prometheus
sudo systemctl restart prometheus

# Check Prometheus status
systemctl status prometheus

# View Prometheus logs
sudo journalctl -u prometheus -f
```

### Systemd Service Management

```bash
# Enable service to start on boot
sudo systemctl enable app-exporter.service

# Start service
sudo systemctl start app-exporter.service

# Stop service
sudo systemctl stop app-exporter.service

# Restart service
sudo systemctl restart app-exporter.service

# Check service status
sudo systemctl status app-exporter.service

# View service logs
sudo journalctl -u app-exporter.service -f

# View last 50 log lines
sudo journalctl -u app-exporter.service -n 50

# Reload systemd after changing service file
sudo systemctl daemon-reload
```

### Testing Metrics

```bash
# Check exporter metrics
curl http://localhost:8000/metrics

# Filter for specific metric
curl http://localhost:8000/metrics | grep app_active_sessions

# Check node_exporter
curl http://localhost:9100/metrics | head -20

# Test metric with promtool
promtool query instant http://localhost:9090 'app_active_sessions'
```

### Network and Connectivity

```bash
# Check if port is listening
sudo netstat -tlnp | grep 8000

# Test connectivity to exporter
telnet worker-node 8000

# Check firewall rules
sudo firewall-cmd --list-all

# Allow port through firewall (if needed)
sudo firewall-cmd --permanent --add-port=8000/tcp
sudo firewall-cmd --reload
```

## PromQL Quick Reference

### Basic Queries

```promql
# Instant vector - current value
app_active_sessions

# Filter by label
app_active_sessions{job="app_exporter"}

# Range vector - last 5 minutes
app_active_sessions[5m]
```

### Aggregation Functions

```promql
# Sum across all series
sum(app_active_sessions)

# Average by instance
avg by(instance) (app_active_sessions)

# Maximum value
max(app_active_sessions)

# Count number of series
count(app_active_sessions)
```

### Rate and Derivative Functions

```promql
# Per-second rate over 5 minutes
rate(http_requests_total[5m])

# Rate of change (for gauges)
deriv(app_active_sessions[5m])

# Increase over time range
increase(http_requests_total[1h])
```

### Time Functions

```promql
# Average over time
avg_over_time(app_active_sessions[5m])

# Maximum over time
max_over_time(app_active_sessions[1h])

# Minimum over time
min_over_time(app_active_sessions[1h])
```

### Mathematical Operations

```promql
# Addition
metric1 + metric2

# Percentage calculation
(used / total) * 100

# CPU usage (100 - idle)
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### Comparison Operators

```promql
# Greater than
app_active_sessions > 50

# Less than
app_active_sessions < 20

# Equal to
up == 1

# Not equal
up != 1

# Boolean comparison
app_active_sessions > bool 50
```

## Common Metrics

### Node Exporter Metrics

```promql
# CPU
node_cpu_seconds_total
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory
node_memory_MemTotal_bytes
node_memory_MemAvailable_bytes
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk
node_filesystem_size_bytes
node_filesystem_avail_bytes
(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100

# Network
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])

# Load
node_load1
node_load5
node_load15

# Uptime
time() - node_boot_time_seconds
```

### Custom App Metrics

```promql
# Current value
app_active_sessions

# Average over 5 minutes
avg_over_time(app_active_sessions[5m])

# Maximum in last hour
max_over_time(app_active_sessions[1h])

# Rate of change
deriv(app_active_sessions[5m])
```

## Recording Rule Examples

```yaml
groups:
  - name: example_rules
    interval: 30s
    rules:
      # Simple average
      - record: app:sessions:avg5m
        expr: avg_over_time(app_active_sessions[5m])

      # Aggregation by label
      - record: instance:cpu:usage
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

      # Complex calculation
      - record: instance:memory:usage_percent
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

## Grafana Panel Types

| Panel Type | Best For | Example |
|------------|----------|---------|
| Time series | Trends over time | CPU usage graph |
| Stat | Single current value | Active sessions count |
| Gauge | Percentage/progress | Disk usage % |
| Bar gauge | Multiple percentages | Multi-disk usage |
| Table | Detailed tabular data | Instance list |
| Heatmap | Value distribution | Latency percentiles |

## Common Units in Grafana

- `short` - Raw numbers
- `percent (0-100)` - Percentage
- `percentunit (0.0-1.0)` - Decimal percentage
- `bytes` - Memory sizes
- `bytes/sec` - Transfer rates
- `ops/sec` - Operations per second
- `ms` - Milliseconds
- `s` - Seconds
- `reqps` - Requests per second

## File Locations

### Prometheus
- Config: `/etc/prometheus/prometheus.yml`
- Rules: `/etc/prometheus/rules/*.yml`
- Service Discovery: `/etc/prometheus/file_sd/*.json`
- Data: `/var/lib/prometheus/`

### Grafana
- Config: `/etc/grafana/grafana.ini`
- Dashboards: `/var/lib/grafana/dashboards/`
- Plugins: `/var/lib/grafana/plugins/`

### Systemd
- Service files: `/etc/systemd/system/`
- User services: `~/.config/systemd/user/`

### Custom Exporter
- Installation: `/opt/exporters/app_exporter/`
- Service file: `/etc/systemd/system/app-exporter.service`

## Troubleshooting Checklist

### Exporter Issues
- [ ] Service is running: `systemctl status app-exporter`
- [ ] Port is listening: `netstat -tlnp | grep 8000`
- [ ] Metrics endpoint works: `curl localhost:8000/metrics`
- [ ] Check logs: `journalctl -u app-exporter -f`
- [ ] Verify Python script: `python3 app_exporter.py`

### Prometheus Issues
- [ ] Config is valid: `promtool check config`
- [ ] Target is UP: Check `/targets` page
- [ ] Network connectivity: `curl worker-node:8000/metrics`
- [ ] Service discovery file is valid: `promtool check sd-file`
- [ ] Check logs: `journalctl -u prometheus -f`

### Grafana Issues
- [ ] Data source configured: Check Grafana settings
- [ ] Prometheus is accessible: Test data source
- [ ] Query works in Prometheus: Test query first
- [ ] Panel time range: Check time range settings
- [ ] Check logs: `journalctl -u grafana-server -f`

## Performance Tips

1. **Use recording rules** for expensive queries
2. **Limit time ranges** in dashboards
3. **Use appropriate scrape intervals** (10-60s typical)
4. **Add relabeling** to drop unnecessary labels
5. **Set appropriate retention** (15d default)
6. **Use federation** for scaling
7. **Optimize queries** with label matchers

## Security Best Practices

1. **Run exporters as dedicated user** (not root)
2. **Use firewall rules** to restrict access
3. **Enable authentication** in Grafana
4. **Use TLS** for production
5. **Restrict Prometheus UI** access
6. **Audit dashboard access** regularly
7. **Keep software updated**

## Useful URLs

- Prometheus UI: `http://controller-node:9090`
- Prometheus Targets: `http://controller-node:9090/targets`
- Prometheus Rules: `http://controller-node:9090/rules`
- Grafana: `http://controller-node:3000`
- Node Exporter: `http://worker-node:9100/metrics`
- App Exporter: `http://worker-node:8000/metrics`
