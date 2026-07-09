local Parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	MultiplePackageUpsellShownCounter = {
		eventName = "MultiplePackageUpsellShownCounter",
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
	MultiplePackageUpsellSelectedCounter = {
		eventName = "MultiplePackageUpsellSelectedCounter",
		throttlingPercentage = 100,
		description = "Counter on all multiple package upsell selections",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			5,
			1
		}
	},
	MultiplePackageUpsellModalClosedCounter = {
		eventName = "MultiplePackageUpsellModalClosedCounter",
		throttlingPercentage = 100,
		description = "Counter on all multiple package upsell modal closed",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			5,
			1
		}
	},
	MultiplePackageUpsellModalBuyClickedCounter = {
		eventName = "MultiplePackageUpsellModalBuyClickedCounter",
		throttlingPercentage = 100,
		description = "Counter on all multiple package upsell modal buy clicked",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			5,
			1
		}
	}
}
