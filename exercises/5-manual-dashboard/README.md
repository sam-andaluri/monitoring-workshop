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

## Expected Dashboard Layout

```
┌─────────────────────────────────────────────────────┐
│  Workshop Monitoring Dashboard                      │
├──────────────────────────┬──────────────────────────┤
│                          │                          │
│   Active User Sessions   │    Idle CPU Usage by     │
│         [STAT]           │    Host.                 │
│          45              │    [TIME SERIES]         │
│                          │                          │
├──────────────────────────┼──────────────────────────┤
│                          │                          │
│   Memory Available in GB │    Disk Usage (/)        │
│   [TIME SERIES]          │    [GAUGE]               │
│                          │      65%                 │
│                          │                          │
└──────────────────────────┴──────────────────────────┘
```

## Task

Follow the step-by-step guide in `starter/dashboard_steps.md` to create a complete monitoring dashboard.

Your dashboard should include:

1. **Active Sessions Panel**: Display current active user sessions
2. **CPU Usage Panel**: Show Idle CPU usage over time by instance
3. **Memory Usage Panel**: Display memory usage percentage
4. **Disk Usage Panel**: Show disk usage with color thresholds

## Dashboard Features to Learn

### Panel Types:

- **Time Series**: Line graphs showing data over time
- **Stat**: Single value display with sparkline
- **Gauge**: Semi-circular or linear gauge for percentages

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
5. Setting up units
6. Organizing the layout
7. Configuring dashboard settings
9. Saving the dashboard

## Validation Checklist

- [ ] Dashboard loads without errors
- [ ] All 4 panels display data
- [ ] Queries execute successfully (no red errors)
- [ ] Units are properly configured
- [ ] Dashboard has a meaningful name
- [ ] Panels are organized as per design
- [ ] Legends show hostname


## Dashboard Best Practices

1. **Organization**: Group related metrics together
2. **Clarity**: Use clear titles and descriptions
3. **Colors**: Use color meaningfully (red for problems)
4. **Units**: Always set appropriate units
5. **Time Range**: Set sensible defaults (15m, 1h, 6h)
6. **Refresh Rate**: Balance freshness with load (10-30s)
7. **Legend**: Show instance/host information
8. **Thresholds**: Use industry-standard thresholds

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
