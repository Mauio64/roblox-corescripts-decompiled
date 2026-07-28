local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("GameDetailsSubpageThrottleHundrethsPercent", 10000)
local v6 = t.strictInterface({
	universeId = t.string,
	placeId = t.string,
	subpage = t.string,
	action = t.optional(t.string),
	uid = t.string,
	ctx = t.string
})

return function(p1, s1: string) -- line: 20
	-- upvalues: v6 (copy), DiscoveryEventErrorLogger (copy), v5 (copy), TelemetryService (copy)
	local v9, v10 = v6(p1)

	if not v9 then
		DiscoveryEventErrorLogger.reportError("GameDetailsSubpageInvalidInterface", v10)
	end

	local t1 = {
		eventName = "gameDetailsSubpage",
		description = "User has navigated to a game details subpage",
		backends = { "EventIngest" },
		throttlingPercentage = v5,
		lastUpdated = {
			25,
			11,
			11
		}
	}

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = { "addSessionInfo" },
		customFields = p1
	})
end
