# Exercise 3: PromQL Queries

Complete the following PromQL queries. Fill in the blanks marked with `???`.


## Query 1: Current Active Sessions
Get the current value of active sessions from the custom app exporter.

```promql
???
```

**Expected Result**: Single gauge value of active sessions

> Hint: This is a simple instant vector query that returns the current value of the metric.

---

## Query 2: Average Active Sessions Over 5 Minutes
Calculate the average number of active sessions over the last 5 minutes.

```promql
???
```

**Expected Result**: Single value representing the average

> Hint: `avg_over_time()` calculates the average of all values in the specified time range (5 minutes).

---

## Query 3: CPU Usage Percentage
Calculate the idle CPU usage percentage from node_exporter metrics.

```promql
???
```

**Expected Result**: CPU usage percentage per instance

> Hints:
- `node_cpu_seconds_total{mode="idle"}` gives idle CPU time
- `rate(...[5m])` calculates the per-second rate over 5 minutes
- `avg by(instance)` averages across all CPU cores for each instance
- Subtracting idle percentage from 100 gives usage percentage

---

## Query 4: Available Memory in GB
Get the available memory in gigabytes from node_exporter.

```promql
???
```

**Expected Result**: Available memory in GB

>Hint: Divides bytes by 1024³ (1,073,741,824) to convert to gigabytes.

---

## Query 5: Disk Usage Percentage
Calculate the disk usage percentage for the root filesystem.

```promql
???
```

**Expected Result**: Disk usage percentage for root filesystem

> Hints:
- `node_filesystem_avail_bytes` gives available bytes
- `node_filesystem_size_bytes` gives total size
- Division gives available ratio
- Subtracting from 1 gives used ratio
- Multiplying by 100 converts to percentage

---

## Bonus Challenge

Write a query that alerts when active sessions drop below 20:

```promql
???
```
>Hint: The comparison operator returns the metric only when the condition is true. The `bool` modifier returns 0 or 1 instead of filtering results.

---

## Additional Useful Queries

### Query 6: Rate of Change in Active Sessions
```promql
???
```

### Query 7: Maximum Active Sessions in Last Hour
```promql
???
```

### Query 8: Network Receive Rate (bytes/sec)
```promql
???
```

### Query 9: System Load Average
```promql
???
```

### Query 10: Memory Usage Percentage
```promql
???
```
