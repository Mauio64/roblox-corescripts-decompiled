require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local FFlagBuildAnalyticsGoals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsGoals")

local function getMetricQueryParams(p2, p3, p4, p5)
	local metricQueryParams = {
		universeId = p2,
		metric = p3.id,
		granularity = p4.granularity,
		lookbackSeconds = p4.lookbackSeconds * 2,
		endTime = p5,
		filters = 0
	}

	local v5 = if FFlagBuildAnalyticsGoals then p3.filters else nil
	metricQueryParams.filters = v5
	return metricQueryParams
end

return getMetricQueryParams
