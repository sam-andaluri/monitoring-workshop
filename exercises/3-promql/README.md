# Exercise 3: Writing PromQL Queries

## Objective
Learn how to write PromQL (Prometheus Query Language) queries to extract and analyze metrics from both the custom app_exporter and node_exporter.

## Prerequisites
- Completed Exercise 1 and 2
- Prometheus scraping both app_exporter and node_exporter

## Background

**PromQL** is Prometheus's query language. It allows you to:
- Select and aggregate time series data
- Perform mathematical operations on metrics
- Filter data using labels
- Apply functions for analysis (rate, avg, sum, etc.)

### Key Concepts:

1. **Instant Vector**: A set of time series containing a single sample for each time series (e.g., `node_cpu_seconds_total`)
2. **Range Vector**: A set of time series containing a range of data points over time (e.g., `node_cpu_seconds_total[5m]`)
3. **Scalar**: A simple numeric floating point value (e.g., `100.5`)

### Common Functions:
- `rate()`: Calculate per-second average rate of increase
- `avg_over_time()`: Average value over time
- `sum()`: Sum values across dimensions
- `max()`, `min()`: Maximum/minimum values
- `by()`: Group by specific labels

## Task

Complete the queries in `starter/promql_queries.md`. 
You need to write 5 PromQL queries and test them using `promtool`.
The queries from 6 thru 10 and the bonus are a stretch goal.

To complete this task, you need to write 5 PromQL queries:
1. **Query 1**: Get current active sessions (using app_exporter metric)
2. **Query 2**: Calculate average active sessions over time (using app_exporter metric)
3. **Query 3**: Calculate CPU usage percentage (using node_exporter)
4. **Query 4**: Get available memory in GB (using node_exporter)
5. **Query 5**: Calculate disk usage percentage (using node_exporter)

The following are optional bonus queries (if you have time)
6. **Query 6**: Rate of Change in Active Sessions
7. **Query 7**: Maximum Active Sessions in Last Hour
8. **Query 8**: Network Receive Rate (bytes/sec)
9. **Query 9**: System Load Average
10. **Query 10**: Memory Usage Percentage

11. **Bonus Challenge**: Alert when active sessions drop below 20

## Testing Your Queries

### Use promtool:

```bash
promtool query instant http://controller-node:9090 'app_active_sessions'
```

## Validation

For each query, verify, you are seeing the expected results. 

## Common node_exporter Metrics

Here are some useful node_exporter metrics you can explore:

- `node_cpu_seconds_total`: CPU time in seconds
- `node_memory_MemTotal_bytes`: Total memory
- `node_memory_MemAvailable_bytes`: Available memory
- `node_filesystem_size_bytes`: Filesystem size
- `node_filesystem_avail_bytes`: Available filesystem space
- `node_network_receive_bytes_total`: Network received bytes
- `node_network_transmit_bytes_total`: Network transmitted bytes
- `node_load1`: 1-minute load average

## Tips

1. **Check labels**: Use `{label="value"}` to filter metrics
2. **Time ranges**: For range vectors, use `[5m]`, `[1h]`, `[1d]`, etc.
3. **Test incrementally**: Build complex queries step by step
4. **Format output**: Use `by (label)` to group results

## Expected Output

Each query should:
- Execute without syntax errors
- Return relevant metrics
- Display reasonable values for the metric type

## Troubleshooting

- **Syntax error**: Review PromQL syntax documentation
- **Unexpected values**: Verify metric units (bytes, seconds, etc.)

## Learning Points
- PromQL syntax and query structure
- Working with instant and range vectors
- Using aggregation functions
- Metric arithmetic and transformations
- Label filtering and grouping
