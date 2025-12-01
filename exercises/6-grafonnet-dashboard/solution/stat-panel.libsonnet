local g = import '../g.libsonnet';

function(title, promql, legend, gridPos)
  g.panel.stat.new(title)
    + g.panel.stat.queryOptions.withTargets([
        g.query.prometheus.new(
          '$PROMETHEUS_DS',
          promql,
        )
        + g.query.prometheus.withLegendFormat(legend)
      ])
    + g.panel.stat.gridPos.withW(gridPos.w)
    + g.panel.stat.gridPos.withH(gridPos.h)
    + g.panel.stat.gridPos.withX(gridPos.x)
    + g.panel.stat.gridPos.withY(gridPos.y)
    + g.panel.stat.options.withOrientation('vertical')
    + g.panel.stat.options.withTextMode('auto')
    + g.panel.stat.options.withColorMode('value')
    + g.panel.stat.options.withGraphMode('none')
    + g.panel.stat.options.withJustifyMode('auto')
    + g.panel.stat.options.withWideLayout(true)
    
    