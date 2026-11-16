local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/LoggingProtocol")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")

local reportWarning = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Points/reportWarning")

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

local v5 = {
	eventName = "GameAttributionError",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 7, 30 },
	description = "Tracks failures to resolve game attribution errors"
}

local function reportGameAttributionError(p2, p3)
	local v6, v7 = strictInterface(p3)

	if not v6 then
		reportWarning(LoggingProtocol.default, "EventLogging", v7)
	end

	LoggingProtocol.default:logRobloxTelemetryEvent(
		v5,
		{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
		p3,
		p2
	)
end

return reportGameAttributionError
