local HttpService = game:GetService("HttpService")

local chatOpenTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat").chatOpenTelemetry

local function getBuildExperienceEventFields(p2, data, p3)
	local eventIds, v5 = chatOpenTelemetry.resolveEventIds(
		data.chatOpenId,
		data.conversationId,
		data.universeId
	)
	local conversationId = data.conversationId or v5
	local buildExperienceEventFields = {
		eventType = p2,
		universeId = data.universeId,
		placeId = data.placeId,
		conversationId = conversationId,
		messageId = data.messageId,
		turnId = data.turnId,
		chatOpenId = eventIds,
		parameters = 0
	}

	local v6 = if p3 then HttpService:JSONEncode(p3) else nil
	buildExperienceEventFields.parameters = v6
	return buildExperienceEventFields
end

return getBuildExperienceEventFields
