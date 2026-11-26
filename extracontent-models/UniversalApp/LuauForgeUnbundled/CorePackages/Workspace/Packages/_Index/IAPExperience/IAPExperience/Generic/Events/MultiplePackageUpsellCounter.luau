local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol")

return {
	MultiplePackageUpsellShownCounter = {
		eventName = "MultiplePackageUpsellShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 1 },
		throttlingPercentage = 100,
		description = "Counter on all multiple package upsell shown",
		links = ""
	},
	MultiplePackageUpsellSelectedCounter = {
		eventName = "MultiplePackageUpsellSelectedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 1 },
		throttlingPercentage = 100,
		description = "Counter on all multiple package upsell selections"
	},
	MultiplePackageUpsellModalClosedCounter = {
		eventName = "MultiplePackageUpsellModalClosedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 1 },
		throttlingPercentage = 100,
		description = "Counter on all multiple package upsell modal closed"
	},
	MultiplePackageUpsellModalBuyClickedCounter = {
		eventName = "MultiplePackageUpsellModalBuyClickedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2025, 5, 1 },
		throttlingPercentage = 100,
		description = "Counter on all multiple package upsell modal buy clicked"
	}
}
