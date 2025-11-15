# Exercise 3: Writing PromQL Queries

## Objective
Learn how to write PromQL (Prometheus Query Language) queries to extract and analyze metrics from both the custom app_exporter and node_exporter.

## Prerequisites
- Completed Exercise 1 and 2
- Prometheus scraping both app_exporter and node_exporter
- Access to Prometheus UI at `http://controller-node:9090`

## Background

**PromQL** is Prometheus's query language. It allows you to:
- Select and aggregate time series data
- Perform mathematical operations on metrics
- Filter data using labels
- Apply functions for analysis (rate, avg, sum, etc.)

### Key Concepts:

1. **Instant Vector**: A set of time series containing a single sample for each time series
2. **Range Vector**: A set of time series containing a range of data points over time
3. **Scalar**: A simple numeric floating point value
4. **String**: A string value (currently unused)

### Common Functions:
- `rate()`: Calculate per-second average rate of increase
- `avg_over_time()`: Average value over time
- `sum()`: Sum values across dimensions
- `max()`, `min()`: Maximum/minimum values
- `by()`: Group by specific labels

## Task

Complete the queries in `starter/promql_queries.md`. You need to write 5 PromQL queries:

1. **Query 1**: Get current active sessions (using app_exporter metric)
2. **Query 2**: Calculate average active sessions over time (using app_exporter metric)
3. **Query 3**: Calculate CPU usage percentage (using node_exporter)
4. **Query 4**: Get available memory in GB (using node_exporter)
5. **Query 5**: Calculate disk usage percentage (using node_exporter)

## Testing Your Queries

### Using Prometheus UI:

1. Navigate to `http://controller-node:9090`
2. Click on "Graph" tab
3. Enter your query in the expression box
4. Click "Execute"
5. View results in Table or Graph view

### Using curl (API):

```bash
# Test a query via HTTP API
curl -G 'http://controller-node:9090/api/v1/query' \
  --data-urlencode 'query=app_active_sessions'
```

### Using promtool:

```bash
# Query via command line
promtool query instant http://controller-node:9090 'app_active_sessions'
```

## Validation

For each query, verify:

1. **Syntax**: Query executes without errors
2. **Results**: Returns expected data
3. **Labels**: Correct instance/job labels present
4. **Values**: Reasonable numeric values

### Example Validation:

```bash
# Check if metric exists
curl -s 'http://controller-node:9090/api/v1/query?query=app_active_sessions' | jq '.data.result'

# Should return something like:
# [
#   {
#     "metric": {
#       "__name__": "app_active_sessions",
#       "instance": "worker-node:8000",
#       "job": "app_exporter"
#     },
#     "value": [1699564800, "45"]
#   }
# ]
```

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

1. **Use the metrics browser**: In Prometheus UI, start typing to see autocomplete suggestions
2. **Check labels**: Use `{label="value"}` to filter metrics
3. **Time ranges**: For range vectors, use `[5m]`, `[1h]`, `[1d]`, etc.
4. **Test incrementally**: Build complex queries step by step
5. **Format output**: Use `by (label)` to group results

## Expected Output

Each query should:
- Execute without syntax errors
- Return relevant metrics
- Show appropriate labels (instance, job, etc.)
- Display reasonable values for the metric type

## Troubleshooting

- **No data returned**: Check if targets are UP in `/targets`
- **Syntax error**: Review PromQL syntax documentation
- **Unexpected values**: Verify metric units (bytes, seconds, etc.)
- **Empty result**: Ensure label selectors match actual labels

## Learning Points
- PromQL syntax and query structure
- Working with instant and range vectors
- Using aggregation functions
- Metric arithmetic and transformations
- Label filtering and grouping
