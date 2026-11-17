local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local function useBuildPageImpression(page: string, data, flag: boolean?)
	local universeId

	if data == nil then
		universeId = nil
	else
		universeId = data.universeId
	end

	local placeId

	if data == nil then
		placeId = nil
	else
		placeId = data.placeId
	end

	local sessionId

	if data == nil then
		sessionId = nil
	else
		sessionId = data.sessionId
	end

	local v = flag ~= false
	React.useEffect(function()
		if not v then
			return
		end

		sendBuildExperienceEvent(
			"PAGE_IMPRESSION",
			{ universeId = universeId, placeId = placeId, conversationId = sessionId },
			{
				page = page,
				isInExperience = game.GameId == 0 and "false" or "true"
			}
		)
	end, { page, universeId, v })
end

return useBuildPageImpression
