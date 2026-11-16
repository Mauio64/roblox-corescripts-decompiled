local CreatorAnalyticsStoreTypes = require(script.CreatorAnalyticsStoreTypes)
require(script.GoalMilestonesTypes)

return {
	createCreatorAnalyticsStore = require(script.createCreatorAnalyticsStore),
	getCreatorAnalyticsStore = require(script.getCreatorAnalyticsStore),
	createExperienceAnalyticsStore = require(script.createCreatorAnalyticsStore),
	getExperienceAnalyticsStore = require(script.getCreatorAnalyticsStore),
	createGoalMilestonesStore = require(script.createGoalMilestonesStore),
	getGoalMilestonesStore = require(script.getGoalMilestonesStore),
	MetricId = CreatorAnalyticsStoreTypes.MetricId,
	MetricGranularity = CreatorAnalyticsStoreTypes.MetricGranularity,
	FilterOperation = CreatorAnalyticsStoreTypes.FilterOperation,
	ResourceType = CreatorAnalyticsStoreTypes.ResourceType,
	DataStatus = CreatorAnalyticsStoreTypes.DataStatus
}
