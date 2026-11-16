local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("GameDetailsSubpageThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface({
	universeId = t.string,
	placeId = t.string,
	subpage = t.string,
	action = t.optional(t.string),
	uid = t.string,
	ctx = t.string
})

return function(customFields, eventContext: string)
	local v, v2 = strictInterface(customFields)

	if not v then
		DiscoveryEventErrorLogger.reportError("GameDetailsSubpageInvalidInterface", v2)
	end

	TelemetryService:LogEvent({
		eventName = "gameDetailsSubpage",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 11, 11 },
		description = "User has navigated to a game details subpage"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
