local MetricChart = require(script.Components.MetricChart.MetricChart)
require(script.Components.MetricChart.MetricChartTypes)
local MetricChartView = require(script.Components.MetricChart.MetricChartView)
local chartLayout = require(script.Components.MetricChart.chartLayout)
return {
	MetricChart = MetricChart,
	MetricChartView = MetricChartView,
	deriveChartAxes = require(script.Utils.deriveChartAxes),
	chartLayout = chartLayout,
	["jest.config"] = script["jest.config"]
}
