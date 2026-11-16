local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local AnalyticsKeys = require(BuildExperience.Analytics.AnalyticsKeys)
local MetricGranularity = CreatorAnalytics.MetricGranularity

local windowId = { LastWeek = "LastWeek", LastMonth = "LastMonth" }

local function dailyWindow(id: string, labelKey: string, days: number, creatorHubRangeType: string) -- 2 equivalent calls inferred from this helper
	return {
		id = id,
		labelKey = labelKey,
		lookbackSeconds = days * 86400,
		days = days,
		granularity = MetricGranularity.OneDay,
		creatorHubRangeType = creatorHubRangeType
	}
end

local lastWeek = dailyWindow(windowId.LastWeek, AnalyticsKeys.ANALYTICS_WINDOW_LAST_WEEK, 7, "Last7Days") -- inferred equivalent call
local lastMonth = dailyWindow(windowId.LastMonth, AnalyticsKeys.ANALYTICS_WINDOW_LAST_MONTH, 28, "Last28Days") -- inferred equivalent call

local windows = { lastMonth, lastWeek }

local windowById = {}

for _, v in windows do
	windowById[v.id] = v
end

return {
	Windows = windows,
	WindowById = windowById,
	WindowId = windowId,
	LastWeek = lastWeek,
	LastMonth = lastMonth,
	DEFAULT_WINDOW_ID = windowId.LastWeek
}
