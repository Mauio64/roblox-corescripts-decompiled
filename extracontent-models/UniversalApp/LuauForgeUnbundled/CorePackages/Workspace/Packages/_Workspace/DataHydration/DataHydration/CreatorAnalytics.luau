local CreatorAnalyticsStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/CreatorAnalyticsStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/GoalMilestonesTypes")

return {
	createCreatorAnalyticsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/createCreatorAnalyticsStore"),
	getCreatorAnalyticsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/getCreatorAnalyticsStore"),
	createExperienceAnalyticsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/createCreatorAnalyticsStore"),
	getExperienceAnalyticsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/getCreatorAnalyticsStore"),
	createGoalMilestonesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/createGoalMilestonesStore"),
	getGoalMilestonesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/getGoalMilestonesStore"),
	MetricId = CreatorAnalyticsStoreTypes.MetricId,
	MetricGranularity = CreatorAnalyticsStoreTypes.MetricGranularity,
	FilterOperation = CreatorAnalyticsStoreTypes.FilterOperation,
	ResourceType = CreatorAnalyticsStoreTypes.ResourceType,
	DataStatus = CreatorAnalyticsStoreTypes.DataStatus
}
