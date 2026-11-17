local BuildExperience = script:FindFirstAncestor("BuildExperience")

require(BuildExperience.Analytics.AnalyticsWindow)
require(BuildExperience.Analytics.Goals.GoalLockedActionId)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagBuildExperienceEventContextTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceEventContextTelemetry)

local function getGranularity(universeId: number, p)
	local placeId

	if p ~= nil then
		placeId = p.placeId
	end

	local conversationId

	if p ~= nil then
		conversationId = p.conversationId
	end

	return { universeId = universeId, placeId = placeId, conversationId = conversationId }
end

local AnalyticsPageEvents = {}

function AnalyticsPageEvents.goalImpression(universeId: number, goalId: string, state: string, windowId, p)
	local v

	if FFlagBuildExperienceEventContextTelemetry then
		v = { universeId = universeId, placeId = 0, conversationId = 0 }
		local placeId

		if p ~= nil then
			placeId = p.placeId
		end

		v.placeId = placeId
		local conversationId

		if p ~= nil then
			conversationId = p.conversationId
		end

		v.conversationId = conversationId
	else
		v = { universeId = universeId }
	end

	sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_IMPRESSION", v, {
		goalId = goalId,
		state = state,
		windowId = windowId
	})
end

function AnalyticsPageEvents.goalClick(universeId: number, goalId: string, p)
	local v

	if FFlagBuildExperienceEventContextTelemetry then
		v = { universeId = universeId, placeId = 0, conversationId = 0 }
		local placeId

		if p ~= nil then
			placeId = p.placeId
		end

		v.placeId = placeId
		local conversationId

		if p ~= nil then
			conversationId = p.conversationId
		end

		v.conversationId = conversationId
	else
		v = { universeId = universeId }
	end

	sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CLICK", v, { goalId = goalId })
end

function AnalyticsPageEvents.goalCtaImpression(universeId: number, goalId: string, actionId, slot: string, p)
	local v

	if FFlagBuildExperienceEventContextTelemetry then
		v = { universeId = universeId, placeId = 0, conversationId = 0 }
		local placeId

		if p ~= nil then
			placeId = p.placeId
		end

		v.placeId = placeId
		local conversationId

		if p ~= nil then
			conversationId = p.conversationId
		end

		v.conversationId = conversationId
	else
		v = { universeId = universeId }
	end

	sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CTA_IMPRESSION", v, {
		goalId = goalId,
		actionId = actionId,
		slot = slot
	})
end

function AnalyticsPageEvents.goalCtaClick(universeId: number, goalId: string, actionId, slot: string, p)
	local v

	if FFlagBuildExperienceEventContextTelemetry then
		v = { universeId = universeId, placeId = 0, conversationId = 0 }
		local placeId

		if p ~= nil then
			placeId = p.placeId
		end

		v.placeId = placeId
		local conversationId

		if p ~= nil then
			conversationId = p.conversationId
		end

		v.conversationId = conversationId
	else
		v = { universeId = universeId }
	end

	sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CTA_CLICK", v, {
		goalId = goalId,
		actionId = actionId,
		slot = slot
	})
end

return AnalyticsPageEvents
