local parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

return {
	SinglePackageUpsellShownCounter = {
		eventName = "SinglePackageUpsellShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 1 },
		throttlingPercentage = 100,
		description = "Counter on all multiple package upsell shown",
		links = ""
	},
	SinglePackageUpsellModalClosedCounter = {
		eventName = "SinglePackageUpsellModalClosedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 1 },
		throttlingPercentage = 100,
		description = "Counter on all single package upsell modal closed"
	},
	SinglePackageUpsellModalBuyClickedCounter = {
		eventName = "SinglePackageUpsellModalBuyClickedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 1 },
		throttlingPercentage = 100,
		description = "Counter on all single package upsell modal buy clicked"
	}
}
