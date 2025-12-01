local g = import './g.libsonnet';
local variables = import './workshop-dashboard-variables.libsonnet';
local timeseriesPanel = import './timeseries-panel.libsonnet';
local statPanel = import './stat-panel-single.libsonnet';
local tempGuagePanel = import './gauge-panel.libsonnet';
local statPanelXid = import './stat-panel.libsonnet';
local utilGaugePanel = import './gauge-panel-util.libsonnet';

g.dashboard.new('NVIDIA GPU Metrics')
+ g.dashboard.withUid('nvidia-gpu-metrics-single')
+ g.dashboard.withDescription(|||
  GPU Metrics Dashboard for a single cluster node.
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
      'avg by (Hostname) (DCGM_FI_DEV_GPU_UTIL{Hostname=~"$hostname", oci_name=~"$oci_name"})',
      {w:4, h:4, x:12, y:0}
    ),    
])
