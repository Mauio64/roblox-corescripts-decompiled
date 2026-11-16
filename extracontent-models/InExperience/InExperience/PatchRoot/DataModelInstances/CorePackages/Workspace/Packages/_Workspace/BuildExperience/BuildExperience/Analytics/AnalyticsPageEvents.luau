local BuildExperience = script:FindFirstAncestor("BuildExperience")

require(BuildExperience.Analytics.AnalyticsWindow)
require(BuildExperience.Analytics.Goals.GoalLockedActionId)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local AnalyticsPageEvents = {}

function AnalyticsPageEvents.goalImpression(universeId: number, goalId: string, state: string, windowId)
	sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_IMPRESSION", { universeId = universeId }, {
		goalId = goalId,
		state = state,
		windowId = windowId
	})
end

function AnalyticsPageEvents.goalClick(universeId: number, goalId: string)
	sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CLICK", { universeId = universeId }, {
		goalId = goalId
	})
end

function AnalyticsPageEvents.goalCtaImpression(universeId: number, goalId: string, actionId, slot: string)
	sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CTA_IMPRESSION", { universeId = universeId }, {
		goalId = goalId,
		actionId = actionId,
		slot = slot
	})
end

function AnalyticsPageEvents.goalCtaClick(universeId: number, goalId: string, actionId, slot: string)
	sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CTA_CLICK", { universeId = universeId }, {
		goalId = goalId,
		actionId = actionId,
		slot = slot
	})
end

return AnalyticsPageEvents
