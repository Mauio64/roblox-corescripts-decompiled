local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/LoggingProtocol")
local default = LoggingProtocol.default

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local navigationEventPrefix = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/navigationEventPrefix")

local v5 = {
	eventName = "LuaAppNavTTIDiscarded",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 11, 10 },
	description = "NavigateTo_ TTI samples dropped instead of sent, labeled by metricName and reason (superseded, backgrounded, joinAttempt, lateFrame). superseded, backgrounded and joinAttempt skip starts that never committed a navigation.",
	links = ""
}

local function logTTIDiscard(value, p2)
	if string.sub(value, 1, #navigationEventPrefix) ~= navigationEventPrefix then
		return
	end

	default:logRobloxTelemetryCounter(v5, 1, { metricName = value, reason = p2 })
end

return logTTIDiscard
