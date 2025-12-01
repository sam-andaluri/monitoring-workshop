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

## Thought Experiment 2

### Law of Averages and Percentiles 

Assume the following CPU usage percentages scraped by Prometheus.

| Time (min) | CPU (%) |
|:----------:|:-------:|
| 0m         | 12      |
| 1m         | 18      |
| 2m         | 7       |
| 3m         | 100     |
| 4m         | 22      |
| 5m         | 15      |
| 6m         | 100     |
| 7m         | 9       |
| 8m         | 30      |
| 9m         | 100     |
| 10m        | 5       |
| 11m        | 27      |
| 12m        | 14      |
| 13m        | 100     |
| 14m        | 40      |
| 15m        | 8       |
| 16m        | 23      |
| 17m        | 19      |
| 18m        | 6       |
| 19m        | 11      |

Values array:
[12, 18, 7, 100, 22, 15, 100, 9, 30, 100, 5, 27, 14, 100, 40, 8, 23, 19, 6, 11]

Summary statistics
- n = 20
- sum = 666
- mean = 666 / 20 = 33.3% (Law of Averages)

### Observe

If you look at the average CPU usage it's 33.3%. Customer says there are occassions when their application had slowed down significantly. But the data says probably this node was used only 1/3. This is how averages mislead us.

A better way is to look at percentiles. If you look at our Monitoring within HPC Stack, we adopted 99th, 95th and 90th percentiles to capture these tails. If you look at the 95th and 90th percentiles in the example below, you can see the 100% usage missed by averages. 

Sorted values (ascending):

[5, 6, 7, 8, 9, 11, 12, 14, 15, 18, 19, 22, 23, 27, 30, 40, 100, 100, 100, 100]

Percentiles (interpolated method: rank = p/100 * (n+1), n+1 = 21)
- p25: rank = 5.25 → between 5th (9) and 6th (11) → 9 + 0.25×(11−9) = **9.5%**
- p50 (median): rank = 10.5 → between 10th (18) and 11th (19) → **18.5%**
- p75: rank = 15.75 → between 15th (30) and 16th (40) → 30 + 0.75×10 = **37.5%**
- p90: rank = 18.9 → between 18th (100) and 19th (100) → **100%**
- p95: rank = 19.95 → effectively max → **100%**

Interpretation
- Mean = 33.3% — reflects average but biased by rare 100% spikes.
- Median (p50 = 18.5%) — better represents typical CPU in this skewed series.
- p75 = 37.5% and p90/p95 = 100% — show tail behavior and frequency/severity of spikes.
- For SLOs and tail-latency-like CPU spike detection prefer p90/p95; for overall load use mean but note sensitivity to outliers.

Practical note
- When reporting percentiles, state the calculation method (nearest-rank vs interpolated) and sample window (here: 20 samples at 1m).
- In Prometheus, compute percentiles with histogram summaries or recording rules to avoid expensive repeated queries.

