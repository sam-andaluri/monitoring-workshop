# Exercise 5: Creating a Manual Grafana Dashboard

Follow these steps to create a custom Grafana dashboard. Fill in the missing information marked with `???`.

## Step 1: Access Grafana

1. Navigate to: `???` (Hint: http://controller-node:3000)
2. Login with default credentials (usually admin/admin)
3. Change password if prompted

## Step 2: Create a New Dashboard

1. Click on the `???` button (Hint: "+" icon) in the left sidebar
2. Select `???` from the dropdown menu
3. Click `???` in the top right

## Step 3: Add Active Sessions Panel

1. Click `???` button to add a new panel
2. In the Query section:
   - Data source: Select `???`
   - Metric: Enter `???` (Hint: your custom app metric)
   - Or use the recording rule: `???`
3. In the Panel options (right side):
   - Title: `???`
   - Description: "Real-time active user sessions"
4. In Visualization settings:
   - Type: `???` (Hint: for real-time values)
   - TODO: What unit should you set? `???`
5. Click `???` in top right to save panel

## Step 4: Add CPU Usage Panel

1. Click `???` button again
2. Query section:
   - Metric: `???` (Hint: use the recording rule from Exercise 4)
   - Legend: `{{instance}}`
3. Panel options:
   - Title: `???`
4. Visualization:
   - Type: `???` (Hint: for time series data)
   - Unit: `???` (Hint: percentage)
   - Min: 0, Max: 100
5. Apply and save

## Step 5: Add Memory Usage Panel

1. Add new panel
2. Query:
   - TODO: Write a query to show memory usage percentage
   - Formula: `???`
3. Panel options:
   - Title: "Memory Usage"
4. Visualization:
   - Type: Time series
   - Unit: Percent (0-100)
5. Apply

## Step 6: Add Disk Usage Panel

1. Add new panel
2. Query:
   - TODO: Use your query from Exercise 3 for disk usage
   - Metric: `???`
3. Panel options:
   - Title: "Disk Usage (/)"
4. Visualization:
   - Type: `???` (Hint: good for showing percentage)
   - Unit: Percent (0-100)
   - Thresholds:
     - Green: 0-70
     - Yellow: 70-85
     - Red: 85-100
5. Apply

## Step 7: Organize Dashboard Layout

1. TODO: How do you resize panels? `???`
2. TODO: How do you move panels? `???`
3. Arrange panels in a logical layout:
   - Top row: Active Sessions (large), CPU Usage
   - Bottom row: Memory Usage, Disk Usage

## Step 8: Configure Dashboard Settings

1. Click on dashboard settings (??? icon in top right)
2. General settings:
   - Name: `???`
   - Tags: monitoring, workshop, custom
3. Time options:
   - Auto-refresh: `???` (Hint: 5s, 10s, 30s?)
   - Time range: Last 15 minutes
4. Save settings

## Step 9: Add Variables (Optional)

1. In dashboard settings, go to `???` tab
2. Click "Add variable"
3. Create an instance variable:
   - Name: instance
   - Type: Query
   - Data source: Prometheus
   - Query: `label_values(node_cpu_seconds_total, instance)`
4. TODO: How do you use this variable in queries? `???`

## Step 10: Save Dashboard

1. Click `???` icon in top right
2. Add a descriptive note: "Initial workshop dashboard"
3. TODO: Where are dashboards stored in Grafana? `???`
4. Click Save

## Validation Checklist

Complete the following to verify your dashboard:

- [ ] Dashboard displays in Grafana UI
- [ ] Active Sessions panel shows real-time data
- [ ] CPU Usage panel shows time series graph
- [ ] Memory Usage panel displays correctly
- [ ] Disk Usage panel shows with color thresholds
- [ ] Auto-refresh is working
- [ ] All queries return data without errors
- [ ] Panels are logically organized
- [ ] Dashboard has a meaningful name

## Bonus Tasks

Try these additional features:

1. **Add alert threshold line**:
   - In Active Sessions panel
   - Add threshold at value 20
   - Color: red

2. **Create a stat panel**:
   - Show max sessions in last hour
   - Query: `???`

3. **Add network traffic panel**:
   - Query: `???`
   - Show receive and transmit rates
