local CreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
local AnalyticsKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsKeys")
local metricGranularity = CreatorAnalytics.MetricGranularity

local v5 = { LastWeek = "LastWeek", LastMonth = "LastMonth" }

local function dailyWindow(p2, p3, p4, p5)
	return {
		id = p2,
		labelKey = p3,
		lookbackSeconds = p4 * 86400,
		days = p4,
		granularity = metricGranularity.OneDay,
		creatorHubRangeType = p5
	}
end

local v6 = {
	id = v5.LastWeek,
	labelKey = AnalyticsKeys.ANALYTICS_WINDOW_LAST_WEEK,
	lookbackSeconds = 604800,
	days = 7,
	granularity = metricGranularity.OneDay,
	creatorHubRangeType = "Last7Days"
}
local v7 = {
	id = v5.LastMonth,
	labelKey = AnalyticsKeys.ANALYTICS_WINDOW_LAST_MONTH,
	lookbackSeconds = 2419200,
	days = 28,
	granularity = metricGranularity.OneDay,
	creatorHubRangeType = "Last28Days"
}

local v8 = { v7, v6 }

local v9 = {}

for k, v10 in v8 do
	v9[v10.id] = v10
end

return {
	Windows = v8,
	WindowById = v9,
	WindowId = v5,
	LastWeek = v6,
	LastMonth = v7,
	DEFAULT_WINDOW_ID = v5.LastWeek
}
