local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagGameJoinCardAnalyticsCardId = SharedFlags.FFlagGameJoinCardAnalyticsCardId

require(script.Parent.Types)
require(GameJoinCard.Analytics.useGameJoinCardAnalytics)

local function getTelemetryFields(p)
	local telemetry = p.telemetry
	local universeId = telemetry.universeId
	local telemetryFields = {
		friendId = p.userId,
		universeId = 0,
		absolutePosition = 0,
		joinGameCardId = 0
	}

	if universeId == nil or universeId == "" then
		universeId = nil
	end

	telemetryFields.universeId = universeId
	telemetryFields.absolutePosition = telemetry.absolutePosition
	local joinGameCardId

	if FFlagGameJoinCardAnalyticsCardId then
		joinGameCardId = telemetry.joinGameCardId
	end

	telemetryFields.joinGameCardId = joinGameCardId
	return telemetryFields
end

return getTelemetryFields
