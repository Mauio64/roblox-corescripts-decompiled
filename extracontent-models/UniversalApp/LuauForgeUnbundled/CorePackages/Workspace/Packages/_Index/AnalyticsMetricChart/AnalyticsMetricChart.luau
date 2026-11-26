local module = require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChart")
require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChartTypes")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/MetricChartView")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Components/MetricChart/chartLayout")
return {
	MetricChart = module,
	MetricChartView = module2,
	deriveChartAxes = require("@game/CorePackages/Workspace/Packages/_Index/AnalyticsMetricChart/AnalyticsMetricChart/Utils/deriveChartAxes"),
	chartLayout = module3
}
