local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")

local parent = DiscoveryAnalytics.Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local t = require(parent.t)

local reportWarning = require(DiscoveryAnalytics.Points.reportWarning)

local defineFastInt = game:DefineFastInt("LuaAppGameAttributionErrorEventThrottleHundrethsPercent", 0)

local strictInterface = t.strictInterface({
	errorType = t.string,
	clickedUniverseId = t.string,
	universeId = t.optional(t.string),
	gameSetTypeId = t.optional(t.string),
	gameSetTargetId = t.optional(t.string),
	sortIndex = t.number,
	sortEntryIndex = t.optional(t.number)
})

local v = {
	eventName = "GameAttributionError",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 7, 30 },
	description = "Tracks failures to resolve game attribution errors"
}

local function reportGameAttributionError(p, p2)
	local v2, v3 = strictInterface(p2)

	if not v2 then
		reportWarning(LoggingProtocol.default, "EventLogging", v3)
	end

	LoggingProtocol.default:logRobloxTelemetryEvent(
		v,
		{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
		p2,
		p
	)
end

return reportGameAttributionError
