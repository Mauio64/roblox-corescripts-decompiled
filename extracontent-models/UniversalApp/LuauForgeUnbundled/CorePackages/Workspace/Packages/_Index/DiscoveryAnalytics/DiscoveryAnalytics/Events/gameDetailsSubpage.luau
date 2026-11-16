local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("GameDetailsSubpageThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface({
	universeId = t.string,
	placeId = t.string,
	subpage = t.string,
	action = t.optional(t.string),
	uid = t.string,
	ctx = t.string
})

return function(p2, p3)
	local v5, v6 = strictInterface(p2)

	if not v5 then
		discoveryEventErrorLogger.reportError("GameDetailsSubpageInvalidInterface", v6)
	end

	TelemetryService:LogEvent({
		eventName = "gameDetailsSubpage",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 11, 11 },
		description = "User has navigated to a game details subpage"
	}, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
