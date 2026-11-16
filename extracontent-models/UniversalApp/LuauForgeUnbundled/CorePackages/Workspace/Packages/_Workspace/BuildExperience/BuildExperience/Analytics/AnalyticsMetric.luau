local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local AnalyticsKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsKeys")
local CreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
local AnalyticsUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")
local FFlagBuildAnalyticsGoals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsGoals")
local metricId = CreatorAnalytics.MetricId
local iconName = Foundation.Enums.IconName

local v5 = {
	id = metricId.DailyActiveUsers,
	titleKey = 0,
	unit = 0,
	chartIcon = 0,
	summaryKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	analyzeNameKey = 0,
	overviewPath = "analytics/engagement"
}

local v6 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_DAILY_ACTIVE_USERS else AnalyticsKeys.ANALYTICS_METRIC_TITLE_DAILY_ACTIVE_USERS
v5.titleKey = v6

v5.unit = AnalyticsUnit.Scalar
v5.chartIcon = iconName.ThreePeople

local v7 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD else AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_DAILY_ACTIVE_USERS
v5.summaryKey = v7

local v8 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_DESC_DAILY_ACTIVE_USERS else AnalyticsKeys.ANALYTICS_METRIC_DESC_DAILY_ACTIVE_USERS
v5.descriptionKey = v8

v5.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_DAILY_ACTIVE_USERS
v5.analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_DAILY_ACTIVE_USERS

local v9 = {
	id = metricId.TotalPlayTimeHours,
	titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_TOTAL_PLAYTIME,
	unit = AnalyticsUnit.Temporal,
	chartIcon = iconName.Clock,
	summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_TOTAL_PLAYTIME,
	descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_TOTAL_PLAYTIME,
	analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_TOTAL_PLAYTIME,
	overviewPath = "analytics/engagement"
}

local v10 = {
	id = metricId.RFYPlayThroughRate,
	titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_PLAYTHROUGH_RATE,
	unit = AnalyticsUnit.Percent,
	chartIcon = iconName.CirclePlay,
	summaryKey = 0,
	descriptionKey = 0,
	analyzeNameKey = 0,
	overviewPath = "analytics/acquisition",
	requiredMilestone = "universe_first_home_recommendation_impression_achieved"
}

local v11 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD else AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_PLAYTHROUGH_RATE
v10.summaryKey = v11

v10.descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_PLAYTHROUGH_RATE
v10.analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_PLAYTHROUGH_RATE

local v12 = {
	id = metricId.ForwardD1Retention,
	titleKey = 0,
	unit = 0,
	chartIcon = 0,
	summaryKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	analyzeNameKey = 0,
	overviewPath = "analytics/retention"
}

local v13 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_D1_RETENTION else AnalyticsKeys.ANALYTICS_METRIC_TITLE_D1_RETENTION
v12.titleKey = v13

v12.unit = AnalyticsUnit.Percent
v12.chartIcon = iconName.ArrowRotateRight

local v14 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD else AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_D1_RETENTION
v12.summaryKey = v14

local v15 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_DESC_D1_RETENTION else AnalyticsKeys.ANALYTICS_METRIC_DESC_D1_RETENTION
v12.descriptionKey = v15

v12.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_D1_RETENTION
v12.analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_D1_RETENTION

local v16 = {
	id = metricId.PayingUsersCVR,
	titleKey = 0,
	unit = 0,
	chartIcon = 0,
	summaryKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	analyzeNameKey = 0,
	overviewPath = "analytics/monetization"
}

local v17 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_PAYER_CONVERSION else AnalyticsKeys.ANALYTICS_METRIC_TITLE_PAYER_CONVERSION
v16.titleKey = v17

v16.unit = AnalyticsUnit.Percent
v16.chartIcon = iconName.PersonCheck

local v18 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD else AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_PAYER_CONVERSION
v16.summaryKey = v18

local v19 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_DESC_PAYER_CONVERSION else AnalyticsKeys.ANALYTICS_METRIC_DESC_PAYER_CONVERSION
v16.descriptionKey = v19

v16.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_PAYER_CONVERSION
v16.analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_PAYER_CONVERSION

local v20 = {
	id = metricId.AverageRevenuePerPayingUser,
	titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_ARPPU,
	unit = AnalyticsUnit.Scalar,
	icon = iconName.Robux,
	chartIcon = iconName.Robux,
	summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_ARPPU,
	descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_ARPPU,
	analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_ARPPU,
	overviewPath = "analytics/monetization"
}

local v21 = {
	id = metricId.AveragePlayTimeMinutesPerDAU,
	titleKey = 0,
	summaryKey = 0,
	unit = 0,
	analyzeNameKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	overviewPath = "analytics/engagement",
	filters = 0
}

local v22 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_NEW_USER_SESSION_TIME else AnalyticsKeys.ANALYTICS_METRIC_TITLE_NEW_USER_SESSION_TIME
v21.titleKey = v22

v21.summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
v21.unit = AnalyticsUnit.Minutes

local v23 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_NEW_USER_SESSION_TIME else AnalyticsKeys.ANALYTICS_METRIC_TITLE_NEW_USER_SESSION_TIME
v21.analyzeNameKey = v23

v21.descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_NEW_USER_SESSION_TIME
v21.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_NEW_USER_SESSION_TIME

v21.filters = {
	{
		dimension = "IsNewUser",
		values = { "New" },
		operation = "Equals"
	}
}

local v24 = {
	id = metricId.ForwardD7Retention,
	titleKey = 0,
	summaryKey = 0,
	unit = 0,
	analyzeNameKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	overviewPath = "analytics/retention"
}

local v25 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_D7_RETENTION else AnalyticsKeys.ANALYTICS_METRIC_TITLE_D7_RETENTION
v24.titleKey = v25

v24.summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
v24.unit = AnalyticsUnit.Percent

local v26 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_D7_RETENTION else AnalyticsKeys.ANALYTICS_METRIC_TITLE_D7_RETENTION
v24.analyzeNameKey = v26

v24.descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_D7_RETENTION
v24.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_D7_RETENTION

local v27 = {
	id = metricId.DailyRevenue,
	titleKey = 0,
	summaryKey = 0,
	unit = 0,
	analyzeNameKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	overviewPath = "analytics/monetization"
}

local v28 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_ROBUX_SPENT else AnalyticsKeys.ANALYTICS_METRIC_TITLE_ROBUX_SPENT
v27.titleKey = v28

v27.summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
v27.unit = AnalyticsUnit.Scalar

local v29 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_ROBUX_SPENT else AnalyticsKeys.ANALYTICS_METRIC_TITLE_ROBUX_SPENT
v27.analyzeNameKey = v29

v27.descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_ROBUX_SPENT
v27.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_ROBUX_SPENT

local v30 = { v5, v9, v10, v12, v16, v20 }

local v31 = {}

for k, v32 in v30 do
	v31[v32.id] = v32
end

return {
	OverviewMetrics = v30,
	MetricById = v31,
	DailyActiveUsers = v5,
	TotalPlaytime = v9,
	PlaythroughRate = v10,
	D1Retention = v12,
	PayerConversion = v16,
	Arppu = v20,
	NewUserSessionTime = v21,
	D7Retention = v24,
	RobuxSpent = v27
}
