local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)

local AnalyticsKeys = require(BuildExperience.Analytics.AnalyticsKeys)
local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)
local FFlagBuildAnalyticsGoals = require(BuildExperience.Flags.FFlagBuildAnalyticsGoals)
local MetricId = CreatorAnalytics.MetricId
local IconName = Foundation.Enums.IconName

local dailyActiveUsers = {
	id = MetricId.DailyActiveUsers,
	titleKey = 0,
	unit = 0,
	chartIcon = 0,
	summaryKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	analyzeNameKey = 0,
	overviewPath = "analytics/engagement"
}
local titleKey

if FFlagBuildAnalyticsGoals then
	titleKey = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_DAILY_ACTIVE_USERS
else
	titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_DAILY_ACTIVE_USERS
end

dailyActiveUsers.titleKey = titleKey

dailyActiveUsers.unit = AnalyticsUnit.Scalar
dailyActiveUsers.chartIcon = IconName.ThreePeople
local summaryKey

if FFlagBuildAnalyticsGoals then
	summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
else
	summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_DAILY_ACTIVE_USERS
end

dailyActiveUsers.summaryKey = summaryKey
local descriptionKey

if FFlagBuildAnalyticsGoals then
	descriptionKey = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_DESC_DAILY_ACTIVE_USERS
else
	descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_DAILY_ACTIVE_USERS
end

dailyActiveUsers.descriptionKey = descriptionKey

dailyActiveUsers.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_DAILY_ACTIVE_USERS
dailyActiveUsers.analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_DAILY_ACTIVE_USERS

local totalPlaytime = {
	id = MetricId.TotalPlayTimeHours,
	titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_TOTAL_PLAYTIME,
	unit = AnalyticsUnit.Temporal,
	chartIcon = IconName.Clock,
	summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_TOTAL_PLAYTIME,
	descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_TOTAL_PLAYTIME,
	analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_TOTAL_PLAYTIME,
	overviewPath = "analytics/engagement"
}

local playthroughRate = {
	id = MetricId.RFYPlayThroughRate,
	titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_PLAYTHROUGH_RATE,
	unit = AnalyticsUnit.Percent,
	chartIcon = IconName.CirclePlay,
	summaryKey = 0,
	descriptionKey = 0,
	analyzeNameKey = 0,
	overviewPath = "analytics/acquisition",
	requiredMilestone = "universe_first_home_recommendation_impression_achieved"
}
local summaryKey2

if FFlagBuildAnalyticsGoals then
	summaryKey2 = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
else
	summaryKey2 = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_PLAYTHROUGH_RATE
end

playthroughRate.summaryKey = summaryKey2

playthroughRate.descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_PLAYTHROUGH_RATE
playthroughRate.analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_PLAYTHROUGH_RATE

local d1Retention = {
	id = MetricId.ForwardD1Retention,
	titleKey = 0,
	unit = 0,
	chartIcon = 0,
	summaryKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	analyzeNameKey = 0,
	overviewPath = "analytics/retention"
}
local titleKey2

if FFlagBuildAnalyticsGoals then
	titleKey2 = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_D1_RETENTION
else
	titleKey2 = AnalyticsKeys.ANALYTICS_METRIC_TITLE_D1_RETENTION
end

d1Retention.titleKey = titleKey2

d1Retention.unit = AnalyticsUnit.Percent
d1Retention.chartIcon = IconName.ArrowRotateRight
local summaryKey3

if FFlagBuildAnalyticsGoals then
	summaryKey3 = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
else
	summaryKey3 = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_D1_RETENTION
end

d1Retention.summaryKey = summaryKey3
local descriptionKey2

if FFlagBuildAnalyticsGoals then
	descriptionKey2 = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_DESC_D1_RETENTION
else
	descriptionKey2 = AnalyticsKeys.ANALYTICS_METRIC_DESC_D1_RETENTION
end

d1Retention.descriptionKey = descriptionKey2

d1Retention.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_D1_RETENTION
d1Retention.analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_D1_RETENTION

local payerConversion = {
	id = MetricId.PayingUsersCVR,
	titleKey = 0,
	unit = 0,
	chartIcon = 0,
	summaryKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	analyzeNameKey = 0,
	overviewPath = "analytics/monetization"
}
local titleKey3

if FFlagBuildAnalyticsGoals then
	titleKey3 = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_PAYER_CONVERSION
else
	titleKey3 = AnalyticsKeys.ANALYTICS_METRIC_TITLE_PAYER_CONVERSION
end

payerConversion.titleKey = titleKey3

payerConversion.unit = AnalyticsUnit.Percent
payerConversion.chartIcon = IconName.PersonCheck
local summaryKey4

if FFlagBuildAnalyticsGoals then
	summaryKey4 = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
else
	summaryKey4 = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_PAYER_CONVERSION
end

payerConversion.summaryKey = summaryKey4
local descriptionKey3

if FFlagBuildAnalyticsGoals then
	descriptionKey3 = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_DESC_PAYER_CONVERSION
else
	descriptionKey3 = AnalyticsKeys.ANALYTICS_METRIC_DESC_PAYER_CONVERSION
end

payerConversion.descriptionKey = descriptionKey3

payerConversion.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_PAYER_CONVERSION
payerConversion.analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_PAYER_CONVERSION

local arppu = {
	id = MetricId.AverageRevenuePerPayingUser,
	titleKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_ARPPU,
	unit = AnalyticsUnit.Scalar,
	icon = IconName.Robux,
	chartIcon = IconName.Robux,
	summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_ARPPU,
	descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_ARPPU,
	analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_ANALYZE_NAME_ARPPU,
	overviewPath = "analytics/monetization"
}

local newUserSessionTime = {
	id = MetricId.AveragePlayTimeMinutesPerDAU,
	titleKey = 0,
	summaryKey = 0,
	unit = 0,
	analyzeNameKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	overviewPath = "analytics/engagement",
	filters = 0
}
local titleKey4

if FFlagBuildAnalyticsGoals then
	titleKey4 = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_NEW_USER_SESSION_TIME
else
	titleKey4 = AnalyticsKeys.ANALYTICS_METRIC_TITLE_NEW_USER_SESSION_TIME
end

newUserSessionTime.titleKey = titleKey4

newUserSessionTime.summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
newUserSessionTime.unit = AnalyticsUnit.Minutes
local analyzeNameKey

if FFlagBuildAnalyticsGoals then
	analyzeNameKey = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_NEW_USER_SESSION_TIME
else
	analyzeNameKey = AnalyticsKeys.ANALYTICS_METRIC_TITLE_NEW_USER_SESSION_TIME
end

newUserSessionTime.analyzeNameKey = analyzeNameKey

newUserSessionTime.descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_NEW_USER_SESSION_TIME
newUserSessionTime.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_NEW_USER_SESSION_TIME

newUserSessionTime.filters = {
	{
		dimension = "IsNewUser",
		values = { "New" },
		operation = "Equals"
	}
}

local d7Retention = {
	id = MetricId.ForwardD7Retention,
	titleKey = 0,
	summaryKey = 0,
	unit = 0,
	analyzeNameKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	overviewPath = "analytics/retention"
}
local titleKey5

if FFlagBuildAnalyticsGoals then
	titleKey5 = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_D7_RETENTION
else
	titleKey5 = AnalyticsKeys.ANALYTICS_METRIC_TITLE_D7_RETENTION
end

d7Retention.titleKey = titleKey5

d7Retention.summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
d7Retention.unit = AnalyticsUnit.Percent
local analyzeNameKey2

if FFlagBuildAnalyticsGoals then
	analyzeNameKey2 = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_D7_RETENTION
else
	analyzeNameKey2 = AnalyticsKeys.ANALYTICS_METRIC_TITLE_D7_RETENTION
end

d7Retention.analyzeNameKey = analyzeNameKey2

d7Retention.descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_D7_RETENTION
d7Retention.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_D7_RETENTION

local robuxSpent = {
	id = MetricId.DailyRevenue,
	titleKey = 0,
	summaryKey = 0,
	unit = 0,
	analyzeNameKey = 0,
	descriptionKey = 0,
	improvementKey = 0,
	overviewPath = "analytics/monetization"
}
local titleKey6

if FFlagBuildAnalyticsGoals then
	titleKey6 = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_ROBUX_SPENT
else
	titleKey6 = AnalyticsKeys.ANALYTICS_METRIC_TITLE_ROBUX_SPENT
end

robuxSpent.titleKey = titleKey6

robuxSpent.summaryKey = AnalyticsKeys.ANALYTICS_METRIC_SUMMARY_AVERAGE_OVER_SELECTED_PERIOD
robuxSpent.unit = AnalyticsUnit.Scalar
local analyzeNameKey3

if FFlagBuildAnalyticsGoals then
	analyzeNameKey3 = AnalyticsKeys.ANALYTICS_OVERVIEW_METRIC_TITLE_ROBUX_SPENT
else
	analyzeNameKey3 = AnalyticsKeys.ANALYTICS_METRIC_TITLE_ROBUX_SPENT
end

robuxSpent.analyzeNameKey = analyzeNameKey3

robuxSpent.descriptionKey = AnalyticsKeys.ANALYTICS_METRIC_DESC_ROBUX_SPENT
robuxSpent.improvementKey = AnalyticsKeys.ANALYTICS_IMPROVE_ROBUX_SPENT

local overviewMetrics = {
	dailyActiveUsers,
	totalPlaytime,
	playthroughRate,
	d1Retention,
	payerConversion,
	arppu
}

local metricById = {}

for _, v in overviewMetrics do
	metricById[v.id] = v
end

return {
	OverviewMetrics = overviewMetrics,
	MetricById = metricById,
	DailyActiveUsers = dailyActiveUsers,
	TotalPlaytime = totalPlaytime,
	PlaythroughRate = playthroughRate,
	D1Retention = d1Retention,
	PayerConversion = payerConversion,
	Arppu = arppu,
	NewUserSessionTime = newUserSessionTime,
	D7Retention = d7Retention,
	RobuxSpent = robuxSpent
}
