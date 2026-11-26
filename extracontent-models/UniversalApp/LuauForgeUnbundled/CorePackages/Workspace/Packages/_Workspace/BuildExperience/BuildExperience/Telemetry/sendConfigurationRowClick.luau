local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

local function sendConfigurationRowClick(p2, data, p3)
	local v5 = {
		item = p3,
		context = p2,
		isInExperience = game.GameId == 0 and "false" or "true"
	}

	sendBuildExperienceEvent(
		"CONFIGURATION_ROW_CLICK",
		{
			universeId = data.universeId,
			placeId = data.placeId,
			conversationId = data.sessionId
		},
		v5
	)
end

return sendConfigurationRowClick
