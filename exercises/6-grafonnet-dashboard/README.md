# Exercise 6: Grafonnet

## Objective

Use HPC Stack Grafonnet design elements and libraries to generate the dashboard

## Prerequisites
- Completed Exercises 1-5
- Grafana installed and running on controller node
- Prometheus configured as a Grafana data source
- Metrics available from app_exporter and node_exporter

## Background

Grafonnet turns fragile, bloated Grafana JSON into clean, reusable code to cut redundancy, speed updates, and keep large dashboards maintainable.

- DRY and modular: Replace hundreds of repeated JSON lines with composable, parameterized snippets.
- Easier maintenance: Centralize common attributes; update once, propagate everywhere.
- Readable diffs and reviews: Small, meaningful changes instead of 700–800 line JSON edits.
- Version-control friendly: Treat dashboards like code—branch, review, and rollback confidently.
- Safer, faster iteration: Validate, lint, and generate dashboards via CI/CD, reducing human error.
- Scales with contributions: Standardized libraries and templates make external PRs simpler to review and merge.

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

## References

[Grafonnet Docs](https://grafana.github.io/grafonnet/index.html)

[Grafonnet Units and Value formats](https://github.com/grafana/grafana/blob/main/packages/grafana-data/src/valueFormats/categories.ts)

## [Start here](../6-grafonnet-dashboard/starter/grafonnet-dashboard.md)

