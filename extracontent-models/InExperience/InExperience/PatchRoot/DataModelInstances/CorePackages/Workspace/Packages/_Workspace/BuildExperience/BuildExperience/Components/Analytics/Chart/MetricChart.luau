local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local AnalyticsMetricChart = require(parent.AnalyticsMetricChart)
local React = require(parent.React)

local useMetricChartContent = require(script.Parent.useMetricChartContent)
local useMetricChartViewModel = require(script.Parent.useMetricChartViewModel)
local FFlagBuildAnalyticsSharedMetricChart = require(BuildExperience.Flags.FFlagBuildAnalyticsSharedMetricChart)

local function MetricChart(p)
	if FFlagBuildAnalyticsSharedMetricChart then
		local v = useMetricChartContent(p)
		return React.createElement(AnalyticsMetricChart.MetricChart, v)
	end

	local v = useMetricChartViewModel(p)
	return React.createElement(AnalyticsMetricChart.MetricChartView, v)
end

return MetricChart
