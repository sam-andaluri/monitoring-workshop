local g = import './g.libsonnet';
local variables = import './workshop-dashboard-variables.libsonnet';
local timeseriesPanel = import './timeseries-panel.libsonnet';
local statPanel = import './stat-panel.libsonnet';
local utilGaugePanel = import './gauge-panel-util.libsonnet';

g.dashboard.new('Workshop Dashboard')
+ g.dashboard.withUid('workshop-dashboard-sam')
+ g.dashboard.withDescription(|||
  Workshop Dashboard
|||)
+ g.dashboard.withTimezone('browser')
+ g.dashboard.withRefresh('30s')
+ g.dashboard.time.withFrom('now-5m')
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.prometheus,
  variables.hostname,
  variables.oci_name,
])
+ g.dashboard.withPanels([
    statPanel(
      'Active User Sessions',
      'round(app_active_sessions_avg5m)',
      {w:4, h:8, x:0, y:0}
    ),
    timeseriesPanel(
      'Idle CPU Usage by Host',
      '100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)',
      '{{hostname}}',
      'percent',
      {w:20, h:8, x:8, y:0}
    ),
    timeseriesPanel(
      'Idle CPU Usage by Host',
      'node_memory_MemAvailable_bytes',
      '{{hostname}}',
      'decbytes',
      {w:12, h:8, x:0, y:8}
    ),
    utilGaugePanel(
      'Disk Usage',
      'round((1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100)',
      '{{hostname}}',
      {w:12, h:8, x:12, y:8}
    ),     
])
