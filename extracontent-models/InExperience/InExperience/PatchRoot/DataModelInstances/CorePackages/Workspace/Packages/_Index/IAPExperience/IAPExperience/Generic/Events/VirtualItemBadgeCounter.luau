local parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

return {
	VirtualItemBadgeShownCounter = {
		eventName = "VirtualItemBadgeShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 15 },
		throttlingPercentage = 100,
		description = "Counter on all virtual item badge shown",
		links = ""
	}
}
