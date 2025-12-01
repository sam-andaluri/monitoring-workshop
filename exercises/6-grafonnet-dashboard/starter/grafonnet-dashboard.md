# Conceptual view of Grafonnet code.

## What is Grafonnet?

Grafonnet is a templating language similar to Jinja2 it was based on JSonnet a json based language for templating and patching Kubernetes objects. Grafonnet is the last iteration of Grafana Labs and other community developers who were trying to make Grafana Dashboards as Code. It allows developers to code dashboards, make them into reusable components, use mixins for rapid development and deployment of dashboards.

## Code Walkthrough

Open [workshop-dashboard.jsonnet](workshop-dashboard.jsonnet) and follow along 

### Importing components
Modular files help to make changes to dashboard consistent. All `libsonnet` files are reusable or global files that each dashboard imports. This is similar to how you import python packages from prebuilt libraries. Only exception is that the `.libsonnet` files exist in the current directory in our stack.

```
local variables = import './workshop-dashboard-variables.libsonnet';
local timeseriesPanel = import './timeseries-panel.libsonnet';
local statPanel = import './stat-panel.libsonnet';
local utilGaugePanel = import './gauge-panel-util.libsonnet';
```

### Dashboard configuration
This section of the code represents Dashboard configuration which contains Title, description, timezone (here we choose browser timezone), refresh interval (how often you want to refresh the dashboard), `withFrom('now-5m')` indicates data freshness here that means show me the last 5 minutes data. `withVariables` renders the top filter bar as shown in screenshot below. We don't need this for the dashboard we are building and we did't cover this in our manual dashboard build either. But we can keep the code for variables which would be useful to understand the concept.
![Variables](../../../images/variables.png)

> **1** in the screenshot refers to `withVariables` where you define the variables.

> **2** in the screenshot refers to values of the variables that are queried from prometheus, take a look at [workshop-dashboard-variables.libsonnet](workshop-dashboard-variables.libsonnet)


```
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
```

### Design the panels using predefined functions

Using predefined library functions, we can ensure consistent styling of our dashboards. By using say a component such as timeSeriesPanel you can ensure all time series panels look the same. This also ensures us to make changes consistently. For example, say you want to replace 90th percentile with say 80th percentile across all timeseries panels, you only need to change the library function.

Before
```
function(title, promql, legend, unit, gridPos, legendOptions={
  calcs: ['p99', 'p95', 'p90'],
  displayMode: 'table',
  placement: 'right',
})
```

After (just changing 1 char, you can ensure all dashboards now have 80th percentile instead of 90th percentile)
```
function(title, promql, legend, unit, gridPos, legendOptions={
  calcs: ['p99', 'p95', 'p80'],
  displayMode: 'table',
  placement: 'right',
})
```

Now design the panels using Grafonnet.

Hint:
1. Refer back to the manually created dashboard
2. Access the Panel Options for the panel obtain, width, height, x and y from the panel json.

![panel json](../../../images/panel-json.png)

Complete the [workshop-dashboard.jsonnet](workshop-dashboard.jsonnet)

## Setup (one time only)

Remember you will do this only after all the previous steps were completed.

```
/usr/local/bin/jb init
/usr/local/bin/jb install github.com/grafana/grafonnet-lib/grafonnet@master
/usr/local/bin/jb install github.com/grafana/grafonnet/gen/grafonnet-latest@main
```

## Build dashboard

Once you make the changes to workshop-dashboard.jsonnet, 
1. Set GRAFANA_PASSWORD 
2. run `make all-deploy`

The following command are for your information. I provided a convenient Makefile in the starter and solution which encasulates all the commands below and provides you ways to build json, deploy separately or together in one step with `all-deploy`

```
/usr/local/bin/jsonnet -J vendor workshop-dashboard.jsonnet -o workshop-dashboard.json
```

## Post dashboard to Grafana

Replace `<password>` with your Grafana admin password obtained from Stack
```
GRAFANA_PASSWORD="<password>"
payload="{\"dashboard\": $(jq . workshop-dashboard.json), \"overwrite\": true}"
curl -X POST $BASIC_AUTH -H 'Content-Type: application/json' -d "${payload}" "http://admin:$GRAFANA_PASSWORD@localhost:3000/api/dashboards/db"
```
