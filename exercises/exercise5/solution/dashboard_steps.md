# Exercise 5: Creating a Manual Grafana Dashboard - SOLUTION

Complete step-by-step guide with all answers filled in.

## Step 1: Access Grafana

1. Navigate to: `http://controller-node:3000`
2. Login with default credentials (usually admin/admin)
3. Change password if prompted

## Step 2: Create a New Dashboard

1. Click on the `+` (plus) button in the left sidebar
2. Select `Dashboard` from the dropdown menu
3. Click `Add visualization` in the top right

## Step 3: Add Active Sessions Panel

1. Click `Add` button to add a new panel
2. In the Query section:
   - Data source: Select `Prometheus`
   - Metric: Enter `app_active_sessions`
   - Or use the recording rule: `app:active_sessions:avg5m`
3. In the Panel options (right side):
   - Title: `Active User Sessions`
   - Description: "Real-time active user sessions"
4. In Visualization settings:
   - Type: `Stat` or `Gauge` (for real-time values)
   - Unit: `short` or `none` (for session count)
5. Click `Apply` in top right to save panel

## Step 4: Add CPU Usage Panel

1. Click `Add panel` button again
2. Query section:
   - Metric: `instance:cpu_usage:percent` (the recording rule from Exercise 4)
   - Legend: `{{instance}}`
3. Panel options:
   - Title: `CPU Usage by Instance`
4. Visualization:
   - Type: `Time series` (for time series data)
   - Unit: `Percent (0-100)`
   - Min: 0, Max: 100
5. Apply and save

## Step 5: Add Memory Usage Panel

1. Add new panel
2. Query:
   - Formula: `(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100`
3. Panel options:
   - Title: "Memory Usage"
   - Legend: `{{instance}}`
4. Visualization:
   - Type: Time series
   - Unit: Percent (0-100)
5. Apply

## Step 6: Add Disk Usage Panel

1. Add new panel
2. Query:
   - Metric: `(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100`
3. Panel options:
   - Title: "Disk Usage (/)"
4. Visualization:
   - Type: `Gauge` or `Bar gauge` (good for showing percentage)
   - Unit: Percent (0-100)
   - Thresholds:
     - Green: 0-70
     - Yellow: 70-85
     - Red: 85-100
5. Apply

## Step 7: Organize Dashboard Layout

1. **Resize panels**: Click and drag the bottom-right corner of any panel
2. **Move panels**: Click on the panel title and drag to new position
3. Arrange panels in a logical layout:
   - Top row: Active Sessions (large), CPU Usage
   - Bottom row: Memory Usage, Disk Usage

## Step 8: Configure Dashboard Settings

1. Click on dashboard settings (gear icon in top right)
2. General settings:
   - Name: `Workshop Monitoring Dashboard`
   - Tags: monitoring, workshop, custom
3. Time options:
   - Auto-refresh: `10s` (or 5s, 30s based on preference)
   - Time range: Last 15 minutes
4. Save settings

## Step 9: Add Variables (Optional)

1. In dashboard settings, go to `Variables` tab
2. Click "Add variable"
3. Create an instance variable:
   - Name: instance
   - Type: Query
   - Data source: Prometheus
   - Query: `label_values(node_cpu_seconds_total, instance)`
4. **Use variable in queries**: Reference it as `$instance` in query filters
   - Example: `node_cpu_seconds_total{instance="$instance"}`

## Step 10: Save Dashboard

1. Click `Save` (disk icon) in top right
2. Add a descriptive note: "Initial workshop dashboard"
3. **Dashboard storage**: Dashboards are stored in Grafana's database (SQLite by default, or PostgreSQL/MySQL in production)
4. Click Save

## Validation Checklist

Complete the following to verify your dashboard:

- [x] Dashboard displays in Grafana UI
- [x] Active Sessions panel shows real-time data
- [x] CPU Usage panel shows time series graph
- [x] Memory Usage panel displays correctly
- [x] Disk Usage panel shows with color thresholds
- [x] Auto-refresh is working
- [x] All queries return data without errors
- [x] Panels are logically organized
- [x] Dashboard has a meaningful name

## Bonus Tasks - Solutions

### 1. Add alert threshold line:
   - In Active Sessions panel
   - Go to "Thresholds" section in panel edit
   - Add threshold at value 20
   - Color: red
   - Show threshold line: enabled

### 2. Create a stat panel:
   - Show max sessions in last hour
   - Query: `max_over_time(app_active_sessions[1h])`
   - Visualization: Stat
   - Title: "Max Sessions (1h)"

### 3. Add network traffic panel:
   - Query for receive: `rate(node_network_receive_bytes_total{device!="lo"}[5m])`
   - Query for transmit: `rate(node_network_transmit_bytes_total{device!="lo"}[5m])`
   - Visualization: Time series
   - Unit: bytes/sec
   - Legend: `{{instance}} - {{device}} - RX` and `TX`

## Additional Tips

### Panel Types Reference:

| Panel Type | Best For | Example Use Case |
|------------|----------|------------------|
| Time series | Data over time | CPU, memory trends |
| Stat | Current value | Active sessions count |
| Gauge | Percentage/progress | Disk usage, CPU % |
| Bar gauge | Multiple percentages | Multi-disk usage |
| Table | Detailed data | Instance details |
| Heatmap | Distribution | Latency distribution |

### Common Units:

- `short`: Numbers without units
- `percent (0-100)`: Percentage values
- `bytes`: Memory sizes
- `bytes/sec`: Transfer rates
- `ops/sec`: Operations per second
- `milliseconds`: Time duration

### Useful Query Functions:

```promql
# Rate of change
rate(metric[5m])

# Average over time
avg_over_time(metric[1h])

# Maximum value
max_over_time(metric[24h])

# Aggregation by label
sum by(instance) (metric)

# Multiple metrics in one panel
metric1 or metric2
```

## Dashboard JSON Export

After creating your dashboard, you can export it:

1. Dashboard settings → JSON Model
2. Copy the JSON
3. Use it to version control dashboards
4. Import on other Grafana instances

## Testing the Dashboard

Verify functionality:

```bash
# Generate load to see metrics change
# On worker node:
stress-ng --cpu 2 --timeout 60s

# Watch dashboard update in real-time
# Check that CPU panel shows increased usage
```
