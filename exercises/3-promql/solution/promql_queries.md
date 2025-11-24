# Exercise 3: PromQL Queries

## Query 1: Current Active Sessions
Get the current value of active sessions from the custom app exporter.

```promql
app_active_sessions
```

**Expected Result**: Current gauge value of active sessions

**Explanation**: This is a simple instant vector query that returns the current value of the metric.

---

## Query 2: Average Active Sessions Over 5 Minutes
Calculate the average number of active sessions over the last 5 minutes.

```promql
avg_over_time(app_active_sessions[5m])
```

**Expected Result**: Single value representing the average

**Explanation**: `avg_over_time()` calculates the average of all values in the specified time range (5 minutes).

---

## Query 3: CPU Usage Percentage
Calculate the CPU usage percentage from node_exporter metrics.

```promql
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

**Expected Result**: CPU usage percentage per instance

**Explanation**:
- `node_cpu_seconds_total{mode="idle"}` gives idle CPU time
- `rate(...[5m])` calculates the per-second rate over 5 minutes
- `avg by(instance)` averages across all CPU cores for each instance
- Subtracting idle percentage from 100 gives usage percentage

---

## Query 4: Available Memory in GB
Get the available memory in gigabytes from node_exporter.

```promql
node_memory_MemAvailable_bytes / (1024^3)
```

**Alternative with labels**:
```promql
node_memory_MemAvailable_bytes / 1073741824
```

**Expected Result**: Available memory in GB

**Explanation**: Divides bytes by 1024³ (1,073,741,824) to convert to gigabytes.

---

## Query 5: Disk Usage Percentage
Calculate the disk usage percentage for the root filesystem.

```promql
(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100
```

**Expected Result**: Disk usage percentage for root filesystem

**Explanation**:
- `node_filesystem_avail_bytes` gives available bytes
- `node_filesystem_size_bytes` gives total size
- Division gives available ratio
- Subtracting from 1 gives used ratio
- Multiplying by 100 converts to percentage

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

**Explanation**: The comparison operator returns the metric only when the condition is true. The `bool` modifier returns 0 or 1 instead of filtering results.

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
