local BuildExperience = script:FindFirstAncestor("BuildExperience")

local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local function sendConfigurationRowClick(context: string, data, p: string)
	local v = {
		item = p,
		context = context,
		isInExperience = game.GameId == 0 and "false" or "true"
	}

	sendBuildExperienceEvent(
		"CONFIGURATION_ROW_CLICK",
		{ universeId = data.universeId, placeId = data.placeId, conversationId = data.sessionId },
		v
	)
end

return sendConfigurationRowClick
