local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local mutedError = require(Parent.Loggers).mutedError
local t = require(Parent.t)
local v5 = game:DefineFastInt("DiscoveryVideoEndEventHundredthsPercent", 0)
local v6 = t.strictInterface({
	videoAssetId = t.string,
	videoPlaybackSessionId = t.string,
	endReason = t.string,
	playbackTime = t.number,
	universeId = t.string,
	rootPlaceId = t.string,
	gameSetTypeId = t.optional(t.string),
	sortPos = t.optional(t.number),
	targetUniverseId = t.optional(t.string)
})
local t1 = {
	eventName = "discoveryVideoEnd",
	description = "Fire when discovery video stops playing",
	links = "",
	backends = {
		LoggingProtocol.TelemetryBackends.Points,
		LoggingProtocol.TelemetryBackends.EventIngest
	},
	throttlingPercentage = v5,
	lastUpdated = {
		25,
		4,
		23
	}
}

local function discoveryVideoEndEvent(p1, p2) -- line: 38
	-- upvalues: v6 (copy), mutedError (copy), LoggingProtocol (copy), t1 (copy)
	local v11, v12 = v6(p2)

	if not v11 then
		mutedError(v12)
	end

	LoggingProtocol.default:logRobloxTelemetryEvent(t1, {
		"addSessionInfo",
		LoggingProtocol.StandardizedFields.addOsInfo
	}, p2, p1)
end

return discoveryVideoEndEvent
