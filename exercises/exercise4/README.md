# Exercise 4: Prometheus Recording Rules

## Objective
Learn how to create Prometheus recording rules to pre-compute frequently used or expensive queries, improving query performance.

## Prerequisites
- Completed Exercise 1, 2, and 3
- Understanding of PromQL queries
- Prometheus installed on controller node

## Background

**Recording Rules** allow you to precompute frequently needed or computationally expensive expressions and save their result as a new set of time series. This is useful for:

1. **Performance**: Pre-computing expensive queries
2. **Simplification**: Creating reusable aggregations
3. **Dashboards**: Faster dashboard load times
4. **Alerting**: More efficient alert evaluation

### Naming Convention

Recording rules should follow this naming pattern:
```
level:metric:operations
```

Examples:
- `job:api_requests:rate5m` - Job-level request rate over 5 minutes
- `instance:cpu_usage:percent` - Instance-level CPU usage percentage
- `app:active_sessions:avg5m` - Application-level average sessions

## Task

Complete the `starter/recording_rules.yml` file by creating 2 recording rules:

### Problem 1: App Exporter Recording Rule
Create a recording rule that pre-computes the 5-minute average of active sessions.
- **Rule name**: `app:active_sessions:avg5m`
- **Source metric**: `app_active_sessions`
- **Operation**: Calculate 5-minute average

### Problem 2: Node Exporter Recording Rule
Create a recording rule that pre-computes CPU usage percentage by instance.
- **Rule name**: `instance:cpu_usage:percent`
- **Source metric**: `node_cpu_seconds_total`
- **Operation**: Calculate CPU usage percentage (reuse logic from Exercise 3)

## Deployment Steps

### 1. Complete the Recording Rules File

Edit `starter/recording_rules.yml` and fill in the TODOs.

### 2. Validate the Rules File

Use promtool to validate syntax:

```bash
promtool check rules starter/recording_rules.yml
```

Expected output:
```
Checking starter/recording_rules.yml
  SUCCESS: 2 rules found
```

### 3. Copy Rules to Prometheus

```bash
sudo cp starter/recording_rules.yml /etc/prometheus/rules/recording_rules.yml
```

### 4. Update Prometheus Configuration

Ensure your `/etc/prometheus/prometheus.yml` includes the rule file:

```yaml
rule_files:
  - /etc/prometheus/rules/*.yml
```

### 5. Validate Prometheus Configuration

```bash
promtool check config /etc/prometheus/prometheus.yml
```

### 6. Reload Prometheus

```bash
sudo systemctl reload prometheus
```

Or send a SIGHUP:
```bash
sudo killall -HUP prometheus
```

## Testing Your Recording Rules

### 1. Check Rules are Loaded

Navigate to Prometheus UI: `http://controller-node:9090/rules`

You should see:
- `app_recording_rules` group
- `node_recording_rules` group
- Both rules with their expressions

### 2. Query the Recorded Metrics

In Prometheus UI or via curl:

```bash
# Query the app recording rule
curl -G 'http://controller-node:9090/api/v1/query' \
  --data-urlencode 'query=app:active_sessions:avg5m'

# Query the node recording rule
curl -G 'http://controller-node:9090/api/v1/query' \
  --data-urlencode 'query=instance:cpu_usage:percent'
```

### 3. Compare Performance

Compare query performance between the original and recorded metric:

```bash
# Original query (slower)
curl -G 'http://controller-node:9090/api/v1/query' \
  --data-urlencode 'query=avg_over_time(app_active_sessions[5m])'

# Recorded metric (faster)
curl -G 'http://controller-node:9090/api/v1/query' \
  --data-urlencode 'query=app:active_sessions:avg5m'
```

### 4. Verify Data is Being Recorded

Wait 30 seconds (the interval) and query the metric with a time range:

```bash
curl -G 'http://controller-node:9090/api/v1/query_range' \
  --data-urlencode 'query=app:active_sessions:avg5m' \
  --data-urlencode 'start='$(date -u -d '5 minutes ago' +%s) \
  --data-urlencode 'end='$(date -u +%s) \
  --data-urlencode 'step=15s'
```

## Validation Checklist

- [ ] `promtool check rules` returns SUCCESS
- [ ] Recording rules appear in `/rules` page of Prometheus UI
- [ ] Both recording rules show "Healthy" status
- [ ] Queries return data for both recorded metrics
- [ ] Recorded metrics have appropriate labels
- [ ] No errors in Prometheus logs

### Check Prometheus Logs

```bash
sudo journalctl -u prometheus -f | grep -i "recording"
```

## Expected Output

1. **Rules page** should show:
   ```
   app_recording_rules (2 rules)
   - app:active_sessions:avg5m

   node_recording_rules (2 rules)
   - instance:cpu_usage:percent
   ```

2. **Query results** should return time series data with values

3. **Prometheus logs** should show no errors related to recording rules

## Advanced: Using Recording Rules in Alerts

Once created, you can use recording rules in alert rules:

```yaml
groups:
  - name: app_alerts
    rules:
      - alert: LowActiveSessions
        expr: app:active_sessions:avg5m < 20
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Low active sessions detected"
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Rules don't appear in UI | Check Prometheus config includes rule file path |
| Syntax error | Run `promtool check rules` to validate |
| No data in recorded metrics | Wait for evaluation interval (30s) |
| Rule shows as "Unhealthy" | Check expression syntax and source metrics exist |

## Performance Comparison

Recording rules are especially useful when:
- Query is used in multiple dashboards
- Expression is computationally expensive
- Query involves large time ranges
- Multiple alerts use the same calculation

## Learning Points
- Understanding recording rules purpose and benefits
- Proper naming conventions for recording rules
- Using promtool for validation
- Deploying and managing rule files
- Performance optimization strategies
- Rule evaluation intervals
