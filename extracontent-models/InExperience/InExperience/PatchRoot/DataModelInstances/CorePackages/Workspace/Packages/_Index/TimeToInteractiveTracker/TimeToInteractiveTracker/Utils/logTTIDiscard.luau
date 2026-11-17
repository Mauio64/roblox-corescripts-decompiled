local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local parent = TimeToInteractiveTracker.Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

require(TimeToInteractiveTracker.Stores.types)

local navigationEventPrefix = require(TimeToInteractiveTracker.Utils.navigationEventPrefix)

local v = {
	eventName = "LuaAppNavTTIDiscarded",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 11, 10 },
	description = "NavigateTo_ TTI samples dropped instead of sent, labeled by metricName and reason (superseded, backgrounded, joinAttempt, lateFrame). superseded, backgrounded and joinAttempt skip starts that never committed a navigation.",
	links = ""
}

local function logTTIDiscard(metricName: string, reason)
	if string.sub(metricName, 1, #navigationEventPrefix) ~= navigationEventPrefix then
		return
	end

	default:logRobloxTelemetryCounter(v, 1, { metricName = metricName, reason = reason })
end

return logTTIDiscard
