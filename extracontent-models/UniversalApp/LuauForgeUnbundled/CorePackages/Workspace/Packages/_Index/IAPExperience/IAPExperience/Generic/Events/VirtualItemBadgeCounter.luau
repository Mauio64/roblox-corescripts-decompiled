return {
	VirtualItemBadgeShownCounter = {
		eventName = "VirtualItemBadgeShownCounter",
		backends = { require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 15 },
		throttlingPercentage = 100,
		description = "Counter on all virtual item badge shown",
		links = ""
	}
}
