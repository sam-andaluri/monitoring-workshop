# Exercise 3: PromQL Queries

> The following are only PromQL expressions which you can use in Grafana Explorer UI or on the command line using `promtool`

## Query 1: Current Active Sessions
Get the current value of active sessions from the custom app exporter.

```promql
app_active_sessions
```

```
promtool query instant http://localhost:9090 'app_active_sessions'
```
**Expected Result**: Current gauge value of active sessions

---

## Query 2: Average Active Sessions Over 5 Minutes
Calculate the average number of active sessions over the last 5 minutes.

```promql
avg_over_time(app_active_sessions[5m])
```

```
promtool query instant http://localhost:9090 'avg_over_time(app_active_sessions[5m])'
```

**Expected Result**: Single value representing the average

---

## Query 3: CPU Usage Percentage
Calculate the CPU usage percentage from node_exporter metrics.

```promql
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

**Expected Result**: CPU usage percentage per instance

---

## Query 4: Available Memory in GB
Get the available memory in gigabytes from node_exporter.

```promql
node_memory_MemAvailable_bytes / (1024^3)
```

```promql
node_memory_MemAvailable_bytes / 1073741824
```

**Expected Result**: Available memory in GB

---

## Query 5: Disk Usage Percentage
Calculate the disk usage percentage for the root filesystem.

```promql
(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100
```

**Expected Result**: Disk usage percentage for root filesystem

---

## Bonus Challenge

Write a query that alerts when active sessions drop below 20:

```promql
app_active_sessions < 20
```

**Alternative with better metadata**:
```promql
app_active_sessions < bool 20
```


---

## Additional Useful Queries

### Query 6: Rate of Change in Active Sessions
```promql
deriv(app_active_sessions[5m])
```

### Query 7: Maximum Active Sessions in Last Hour
```promql
max_over_time(app_active_sessions[1h])
```

### Query 8: Network Receive Rate (bytes/sec)
```promql
rate(node_network_receive_bytes_total{device!="lo"}[5m])
```

### Query 9: System Load Average
```promql
node_load1
```

### Query 10: Memory Usage Percentage
```promql
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```
