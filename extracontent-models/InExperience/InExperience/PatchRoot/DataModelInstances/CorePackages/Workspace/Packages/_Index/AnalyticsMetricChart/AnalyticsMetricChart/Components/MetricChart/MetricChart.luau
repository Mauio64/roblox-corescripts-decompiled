local parent = script:FindFirstAncestor("AnalyticsMetricChart").Parent

local React = require(parent.React)

require(script.Parent.MetricChartTypes)
local MetricChartView = require(script.Parent.MetricChartView)
local useMetricChartViewModel = require(script.Parent.useMetricChartViewModel)

local function MetricChart(p)
	local v = useMetricChartViewModel(p)
	return React.createElement(MetricChartView, v)
end

return MetricChart
