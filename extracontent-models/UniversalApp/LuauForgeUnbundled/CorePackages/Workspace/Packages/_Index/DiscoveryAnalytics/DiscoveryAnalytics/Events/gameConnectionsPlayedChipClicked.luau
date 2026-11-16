local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("GameConnectionsPlayedChipClickedThrottleHundredthsPercent", 10000)

local strictInterface = t.strictInterface({
	universeId = t.string,
	placeId = t.string,
	uid = t.string,
	totalConnections = t.number
})

return function(p2, p3)
	local v5, v6 = strictInterface(p2)

	if not v5 then
		discoveryEventErrorLogger.reportError("GameConnectionsPlayedChipClickedInvalidInterface", v6)
	end

	TelemetryService:LogEvent({
		eventName = "gameConnectionsPlayedChipClicked",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 2, 10 },
		description = "User has clicked the connections played chip to open the user list"
	}, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
