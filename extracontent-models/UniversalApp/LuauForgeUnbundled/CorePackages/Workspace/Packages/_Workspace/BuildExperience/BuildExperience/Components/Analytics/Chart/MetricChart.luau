local AnalyticsMetricChart = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AnalyticsMetricChart")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local useMetricChartContent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Chart/useMetricChartContent")
local useMetricChartViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Chart/useMetricChartViewModel")
local FFlagBuildAnalyticsSharedMetricChart = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsSharedMetricChart")

local function MetricChart(p2)
	if FFlagBuildAnalyticsSharedMetricChart then
		local v5 = useMetricChartContent(p2)
		return React.createElement(AnalyticsMetricChart.MetricChart, v5)
	end

	local v5 = useMetricChartViewModel(p2)
	return React.createElement(AnalyticsMetricChart.MetricChartView, v5)
end

return MetricChart
