local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.React)

require(parent.DataHydration.CreatorAnalytics)
require(BuildExperience.Analytics.AnalyticsUnit)
require(BuildExperience.Analytics.AnalyticsMetric)
require(BuildExperience.Analytics.deriveMetricSummary)
require(BuildExperience.Analytics.Goals.GoalLockedActionId)

return {}
