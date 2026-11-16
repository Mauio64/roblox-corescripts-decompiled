local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("GameConnectionsPlayedChipClickedThrottleHundredthsPercent", 10000)

local strictInterface = t.strictInterface({
	universeId = t.string,
	placeId = t.string,
	uid = t.string,
	totalConnections = t.number
})

return function(customFields, eventContext: string)
	local v, v2 = strictInterface(customFields)

	if not v then
		DiscoveryEventErrorLogger.reportError("GameConnectionsPlayedChipClickedInvalidInterface", v2)
	end

	TelemetryService:LogEvent({
		eventName = "gameConnectionsPlayedChipClicked",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 2, 10 },
		description = "User has clicked the connections played chip to open the user list"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
