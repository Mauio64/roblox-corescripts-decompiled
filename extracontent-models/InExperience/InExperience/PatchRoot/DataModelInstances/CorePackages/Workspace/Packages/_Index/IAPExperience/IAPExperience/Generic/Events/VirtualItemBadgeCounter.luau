local Parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	VirtualItemBadgeShownCounter = {
		eventName = "VirtualItemBadgeShownCounter",
		throttlingPercentage = 100,
		description = "Counter on all virtual item badge shown",
		links = "",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			5,
			15
		}
	}
}
