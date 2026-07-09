local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")
local DiscoveryAnalyticsParent = DiscoveryAnalytics.Parent
local LoggingProtocol = require(DiscoveryAnalyticsParent.LoggingProtocol)
local t = require(DiscoveryAnalyticsParent.t)
local reportWarning = require(DiscoveryAnalytics.Points.reportWarning)
local v6 = game:DefineFastInt("LuaAppGameAttributionErrorEventThrottleHundrethsPercent", 0)
local v7 = t.strictInterface({
	errorType = t.string,
	clickedUniverseId = t.string,
	universeId = t.optional(t.string),
	gameSetTypeId = t.optional(t.string),
	gameSetTargetId = t.optional(t.string),
	sortIndex = t.number,
	sortEntryIndex = t.optional(t.number)
})
local t1 = {
	eventName = "GameAttributionError",
	description = "Tracks failures to resolve game attribution errors",
	backends = {
		LoggingProtocol.TelemetryBackends.Points,
		LoggingProtocol.TelemetryBackends.EventIngest
	},
	throttlingPercentage = v6,
	lastUpdated = {
		25,
		7,
		30
	}
}

local function reportGameAttributionError(p1, p2) -- line: 36
	-- upvalues: v7 (copy), reportWarning (copy), LoggingProtocol (copy), t1 (copy)
	local v12, v13 = v7(p2)

	if not v12 then
		reportWarning(LoggingProtocol.default, "EventLogging", v13)
	end

	LoggingProtocol.default:logRobloxTelemetryEvent(t1, {
		"addSessionInfo",
		LoggingProtocol.StandardizedFields.addOsInfo
	}, p2, p1)
end

return reportGameAttributionError
