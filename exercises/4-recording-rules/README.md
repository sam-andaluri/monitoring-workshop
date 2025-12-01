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

## Task

Complete the `starter/workshop_recording_rules.yml` file by creating 2 recording rules:

### Task 1: App Exporter Recording Rule
Create a recording rule that pre-computes the 5-minute average of active sessions.
- **Rule name**: `app_active_sessions_avg5m`
- **Source metric**: `app_active_sessions`
- **Operation**: Calculate 5-minute average

### Task 2: Node Exporter Recording Rule
Create a recording rule that pre-computes CPU usage percentage by instance.
- **Rule name**: `instance_cpu_usage_percent`
- **Source metric**: `node_cpu_seconds_total`
- **Operation**: Calculate CPU usage percentage (reuse logic from Exercise 3)

## Deployment Steps

### 1. Complete the Recording Rules File

Edit `starter/workshop_recording_rules.yml` and fill in the TODOs.

### 2. Validate the Rules File

Use promtool to validate syntax:

```bash
promtool check rules starter/workshop_recording_rules.yml
```

Expected output:
```
Checking starter/workshop_recording_rules.yml
  SUCCESS: 2 rules found
```

### 3. Copy the rules

```bash
sudo cp starter/workshop_recording_rules.yml /etc/prometheus/workshop_recording_rules.yml
```

### 4. Update Prometheus Configuration to add your workshop recording rules

Ensure your `/etc/prometheus/prometheus.yml` includes the rule file:

```yaml
rule_files:
  - recording_rules.yml (Existing)
  - workshop_recording_rules.yml (New)
```

### 5. Validate Prometheus Configuration

```bash
promtool check config /etc/prometheus/prometheus.yml
```

### 6. Reload Prometheus

```bash
sudo systemctl restart prometheus
```

## Testing Your Recording Rules

### 1. Check Rules are Loaded

Login to Grafana UI -> Alert Rules. For reference see [this](../../images/Grafana-recording-rules.png)

### 2. Query the Recorded Metrics

In Grafana UI - Explore or via promtool:

```bash
promtool query instant http://localhost:9090 'app_active_sessions_avg5m'
promtool query instant http://localhost:9090 'instance_cpu_usage_percent'
```

## Learning Points
- Understanding recording rules purpose and benefits
- Proper naming conventions for recording rules
- Using promtool for validation
- Deploying and managing rule files
- Performance optimization strategies
- Rule evaluation intervals

## [Start here](../4-recording-rules/README.md)

