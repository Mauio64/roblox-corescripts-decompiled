local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local chatOpenTelemetry = CreatorAgentChat.chatOpenTelemetry

local function getBuildExperienceEventFields(eventType: string, data, p)
	local eventIds, v = chatOpenTelemetry.resolveEventIds(data.chatOpenId, data.conversationId, data.universeId)
	local conversationId = data.conversationId or v
	local buildExperienceEventFields = {
		eventType = eventType,
		universeId = data.universeId,
		placeId = data.placeId,
		conversationId = conversationId,
		messageId = data.messageId,
		turnId = data.turnId,
		chatOpenId = eventIds,
		parameters = 0
	}
	local parameters

	if p then
		parameters = HttpService:JSONEncode(p)
	end

	buildExperienceEventFields.parameters = parameters
	return buildExperienceEventFields
end

return getBuildExperienceEventFields
