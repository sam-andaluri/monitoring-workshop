# Conceptual view of Grafonnet code.

## What is Grafonnet?

Grafonnet is a templating language similar to Jinja2 it was based on JSonnet a json based language for templating and patching Kubernetes objects. Grafonnet is the last iteration of Grafana Labs and other community developers who were trying to make Grafana Dashboards as Code. It allows developers to code dashboards, make them into reusable components, use mixins for rapid development and deployment of dashboards.

## Code Walkthrough

Open [workshop-dashboard.jsonnet](workshop-dashboard.jsonnet) and follow along 

### Importing components
Modular files help to make changes to dashboard consistent. All `libsonnet` files are reusable or global files that each dashboard imports. This is similar to how you import python packages from prebuilt libraries. Only exception is that the `.libsonnet` files exist in the current directory in our stack.

```
local g = import './g.libsonnet';
local variables = import './workshop-dashboard-variables.libsonnet';
local timeseriesPanel = import './timeseries-panel.libsonnet';
local statPanel = import './stat-panel-single.libsonnet';
local tempGuagePanel = import './gauge-panel.libsonnet';
local statPanelXid = import './stat-panel.libsonnet';
local utilGaugePanel = import './gauge-panel-util.libsonnet';
```

### Dashboard setup
This section of the code represents Dashboard configuration which contains Title, description, timezone (here we choose browser timezone), refresh interval (how often you want to refresh the dashboard), `withFrom('now-5m')` indicates data freshness here that means show me the last 5 minutes data. `withVariables` renders the top filter bar as shown in screenshot below. We don't need this for the dashboard we are building and we did't cover this in our manual dashboard build either. But we can keep the code for variables which would be useful to understand the concept.

```
g.dashboard.new('Command Center')
+ g.dashboard.withUid('command-center')
+ g.dashboard.withDescription(|||
  Command Center
|||)
+ g.dashboard.withTimezone('browser')
+ g.dashboard.withRefresh('30s')
+ g.dashboard.time.withFrom('now-5m')
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.prometheus,
  variables.cluster,
])
```

### 

## Setup (one time only)

```
/usr/local/bin/jb init
/usr/local/bin/jb install github.com/grafana/grafonnet-lib/grafonnet@master
/usr/local/bin/jb install github.com/grafana/grafonnet/gen/grafonnet-latest@main
```

## Build dashboard

```
/usr/local/bin/jsonnet -J vendor workshop-dashboard.jsonnet -o workshop-dashboard.json
```

## Post dashboard to Grafana

```
curl -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer ${token}" -d "${payload}" "http://localhost:3000/api/dashboards/db"

```
