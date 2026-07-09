local Parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	SinglePackageUpsellShownCounter = {
		eventName = "SinglePackageUpsellShownCounter",
		throttlingPercentage = 100,
		description = "Counter on all multiple package upsell shown",
		links = "",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			5,
			1
		}
	},
	SinglePackageUpsellModalClosedCounter = {
		eventName = "SinglePackageUpsellModalClosedCounter",
		throttlingPercentage = 100,
		description = "Counter on all single package upsell modal closed",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			5,
			1
		}
	},
	SinglePackageUpsellModalBuyClickedCounter = {
		eventName = "SinglePackageUpsellModalBuyClickedCounter",
		throttlingPercentage = 100,
		description = "Counter on all single package upsell modal buy clicked",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			5,
			1
		}
	}
}
