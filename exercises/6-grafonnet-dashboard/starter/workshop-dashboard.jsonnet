local g = import './g.libsonnet';
local variables = import './workshop-dashboard-variables.libsonnet';
local timeseriesPanel = import './timeseries-panel.libsonnet';
local statPanel = import './stat-panel.libsonnet';
local utilGaugePanel = import './gauge-panel-util.libsonnet';

g.dashboard.new('Workshop Dashboard')
+ g.dashboard.withUid('workshop-dashboard')
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
      '?? promql',
      '?? legend',
      {w:?, h:?, x:?, y:?}
    ),
    timeseriesPanel(
      'Idle CPU Usage by Host',
      '?? promql',
      '?? legend',
      '?? units',
      {w:?, h:?, x:?, y:?}
    ),
    timeseriesPanel(
      'Idle CPU Usage by Host',
      '?? promql',
      '?? legend',
      '?? units',
      {w:?, h:?, x:?, y:?}
    ),
    utilGaugePanel(
      'Disk Usage',
      '?? promql',
      '?? legend'
      {w:?, h:?, x:?, y:?}
    ),    
])
