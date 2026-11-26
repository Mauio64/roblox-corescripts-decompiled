local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

local function useBuildPageImpression(p2, data, p3)
	local universeId = if data ~= nil then data.universeId else nil
	local placeId = if data ~= nil then data.placeId else nil
	local sessionId = if data ~= nil then data.sessionId else nil
	local v5 = p3 ~= false
	React.useEffect(function()
		if not v5 then
			return
		end

		sendBuildExperienceEvent(
			"PAGE_IMPRESSION",
			{ universeId = universeId, placeId = placeId, conversationId = sessionId },
			{
				page = p2,
				isInExperience = game.GameId == 0 and "false" or "true"
			}
		)
	end, { p2, universeId, v5 })
end

return useBuildPageImpression
