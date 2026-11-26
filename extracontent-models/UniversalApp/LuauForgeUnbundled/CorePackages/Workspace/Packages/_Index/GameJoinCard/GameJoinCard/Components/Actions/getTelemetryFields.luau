local fFlagGameJoinCardAnalyticsCardId = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagGameJoinCardAnalyticsCardId

require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")

local function getTelemetryFields(p2)
	local telemetry = p2.telemetry
	local universeId = telemetry.universeId
	local telemetryFields = {
		friendId = p2.userId,
		universeId = 0,
		absolutePosition = 0,
		joinGameCardId = 0
	}

	if universeId == nil or universeId == "" then
		universeId = nil
	end

	telemetryFields.universeId = universeId
	telemetryFields.absolutePosition = telemetry.absolutePosition
	local v5 = if fFlagGameJoinCardAnalyticsCardId then telemetry.joinGameCardId else nil
	telemetryFields.joinGameCardId = v5
	return telemetryFields
end

return getTelemetryFields
