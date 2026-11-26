local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AnalyticsMetricChart/React")

require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChartTypes")
local MetricChartView = require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChartView")
local useMetricChartViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/useMetricChartViewModel")

local function MetricChart(p2)
	local v5 = useMetricChartViewModel(p2)
	return React.createElement(MetricChartView, v5)
end

return MetricChart
