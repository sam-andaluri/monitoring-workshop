# Exercise 5: Creating a Manual Grafana Dashboard

## Objective
Learn how to manually create a comprehensive monitoring dashboard in Grafana using Prometheus as a data source.

## Prerequisites
- Completed Exercises 1-4
- Grafana installed and running on controller node
- Prometheus configured as a Grafana data source
- Metrics available from app_exporter and node_exporter

## Background

**Grafana** is a popular open-source platform for monitoring and observability. It allows you to:
- Visualize metrics from multiple data sources
- Create custom dashboards
- Set up alerts
- Share dashboards with teams
- Template dashboards with variables

### Key Concepts:

1. **Dashboard**: A collection of panels organized in rows
2. **Panel**: Individual visualization (graph, gauge, table, etc.)
3. **Query**: PromQL expression to fetch data
4. **Visualization**: How data is displayed (time series, stat, gauge, etc.)
5. **Data Source**: Where metrics come from (Prometheus, in our case)

## Task

Follow the step-by-step guide in `starter/dashboard_steps.md` to create a complete monitoring dashboard.

Your dashboard should include:

1. **Active Sessions Panel**: Display current active user sessions
2. **CPU Usage Panel**: Show CPU usage over time by instance
3. **Memory Usage Panel**: Display memory usage percentage
4. **Disk Usage Panel**: Show disk usage with color thresholds

## Dashboard Features to Learn

### Panel Types:

- **Time Series**: Line graphs showing data over time
- **Stat**: Single value display with sparkline
- **Gauge**: Semi-circular or linear gauge for percentages
- **Bar Gauge**: Horizontal/vertical bars for multiple values
- **Table**: Tabular data display

### Panel Options:

- **Title and Description**: Clear labeling
- **Units**: Proper unit selection (percent, bytes, etc.)
- **Legends**: Meaningful legend templates
- **Thresholds**: Color-coded value ranges
- **Time range**: Display time window

## Step-by-Step Process

The `starter/dashboard_steps.md` file guides you through:

1. Accessing Grafana
2. Creating a new dashboard
3. Adding panels with different visualization types
4. Configuring queries
5. Setting up thresholds and units
6. Organizing the layout
7. Configuring dashboard settings
8. Adding variables (optional)
9. Saving the dashboard

Fill in all the `???` blanks as you work through the steps.

## Testing Your Dashboard

### Verify Each Panel:

1. **Check Data**: Each panel should display data
2. **Test Time Range**: Change dashboard time range and verify updates
3. **Test Refresh**: Enable auto-refresh and watch live updates
4. **Check Legends**: Verify instance labels are visible
5. **Test Thresholds**: Verify color changes at threshold values

### Generate Test Load:

```bash
# SSH to worker node
ssh worker-node

# Generate CPU load
stress-ng --cpu 2 --timeout 60s

# Generate memory pressure
stress-ng --vm 1 --vm-bytes 512M --timeout 60s

# Generate disk I/O
stress-ng --hdd 1 --timeout 60s
```

Watch your dashboard respond to these changes.

## Validation Checklist

- [ ] Dashboard loads without errors
- [ ] All 4 panels display data
- [ ] Auto-refresh works (5-30 seconds)
- [ ] Time range selector works
- [ ] Queries execute successfully (no red errors)
- [ ] Units are properly configured
- [ ] Thresholds display with correct colors
- [ ] Dashboard has a meaningful name
- [ ] Panels are organized logically
- [ ] Legends show instance information

## Expected Dashboard Layout

```
┌─────────────────────────────────────────────────────┐
│  Workshop Monitoring Dashboard                      │
├──────────────────────────┬──────────────────────────┤
│                          │                          │
│   Active User Sessions   │    CPU Usage by          │
│         [STAT]           │    Instance              │
│          45              │    [TIME SERIES]         │
│                          │                          │
├──────────────────────────┼──────────────────────────┤
│                          │                          │
│   Memory Usage           │    Disk Usage (/)        │
│   [TIME SERIES]          │    [GAUGE]               │
│                          │      65%                 │
│                          │                          │
└──────────────────────────┴──────────────────────────┘
```

## Advanced Features (Bonus)

Once you complete the basic dashboard, try:

### 1. Dashboard Variables

Create variables to filter by instance:
- Variable name: `instance`
- Use in queries: `{instance="$instance"}`
- Adds dropdown selector to dashboard

### 2. Annotations

Add event markers to time series:
- Mark when services restart
- Show deployment events
- Highlight incidents

### 3. Alert Thresholds

Visual indicators without full alerting:
- Add threshold lines to graphs
- Color backgrounds based on values

### 4. Panel Links

Link panels to detailed views:
- Click Active Sessions → detailed session dashboard
- Click CPU → system details

### 5. Repeating Panels

Automatically create panels per instance:
- Set repeat by `$instance` variable
- One panel per host

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No data in panels | Check Prometheus data source is configured |
| Query errors | Verify PromQL syntax in Prometheus first |
| Panels overlap | Use grid layout and resize carefully |
| Wrong units | Check panel settings → Standard options → Unit |
| No auto-refresh | Enable in dashboard time range controls |
| Can't save dashboard | Check Grafana permissions |

## Dashboard Best Practices

1. **Organization**: Group related metrics together
2. **Clarity**: Use clear titles and descriptions
3. **Colors**: Use color meaningfully (red for problems)
4. **Units**: Always set appropriate units
5. **Time Range**: Set sensible defaults (15m, 1h, 6h)
6. **Refresh Rate**: Balance freshness with load (10-30s)
7. **Legend**: Show instance/host information
8. **Thresholds**: Use industry-standard thresholds

## Example Queries for Common Panels

### System Overview:
```promql
# Uptime
time() - node_boot_time_seconds

# System load
node_load1

# Network errors
rate(node_network_receive_errs_total[5m])
```

### Application Metrics:
```promql
# Request rate
rate(http_requests_total[5m])

# Error rate
rate(http_requests_total{status=~"5.."}[5m])

# Latency (if you have histogram)
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

## Exporting and Sharing

### Export Dashboard JSON:
1. Dashboard settings → JSON Model
2. Copy JSON to file
3. Commit to version control

### Import Dashboard:
1. Click + → Import
2. Paste JSON or upload file
3. Select Prometheus data source
4. Import

### Share Dashboard:
1. Click share icon
2. Get snapshot or direct link
3. Set expiration time
4. Share URL with team

## Resources

- Grafana documentation: https://grafana.com/docs/
- Panel examples: https://play.grafana.org/
- Community dashboards: https://grafana.com/grafana/dashboards/

## Learning Points
- Manual dashboard creation workflow
- Panel type selection and configuration
- Query editor usage
- Visualization options and thresholds
- Dashboard organization and layout
- Variables and templating basics
- Dashboard settings and time controls
- Best practices for effective dashboards
