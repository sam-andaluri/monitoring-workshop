# Exercise 3: PromQL Queries

Complete the following PromQL queries. Fill in the blanks marked with `???`.

## Query 1: Current Active Sessions
Get the current value of active sessions from the custom app exporter.

```promql
# TODO: Write a query to get the app_active_sessions metric
???
```

**Expected Result**: Current gauge value of active sessions

---

## Query 2: Average Active Sessions Over 5 Minutes
Calculate the average number of active sessions over the last 5 minutes.

```promql
# TODO: Write a query using avg_over_time() function for app_active_sessions
# Hint: avg_over_time(metric[time_range])
???
```

**Expected Result**: Single value representing the average

---

## Query 3: CPU Usage Percentage
Calculate the CPU usage percentage from node_exporter metrics.

```promql
# TODO: Calculate CPU usage percentage using node_cpu_seconds_total
# Hint: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
???
```

**Expected Result**: CPU usage percentage per instance

---

## Query 4: Available Memory in GB
Get the available memory in gigabytes from node_exporter.

```promql
# TODO: Convert node_memory_MemAvailable_bytes to GB
# Hint: Divide by (1024^3) to convert bytes to GB
???
```

**Expected Result**: Available memory in GB

---

## Query 5: Disk Usage Percentage
Calculate the disk usage percentage for the root filesystem.

```promql
# TODO: Calculate disk usage percentage using node_filesystem metrics
# Hint: (1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100
???
```

**Expected Result**: Disk usage percentage for root filesystem

---

## Bonus Challenge

Write a query that alerts when active sessions drop below 20:

```promql
# TODO: Write a query that returns results only when app_active_sessions < 20
# Hint: Use comparison operators
???
```
