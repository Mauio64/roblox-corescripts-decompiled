local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local LoggingProtocol = require(InExperienceShopParent.LoggingProtocol)
local FIntInExperienceShopTelemetryThrottleHundredthsPercent = require(InExperienceShop.Flags.FIntInExperienceShopTelemetryThrottleHundredthsPercent)

return {
	eventName = "InExperienceShop_Open",
	description = "Counter fired every time the in-experience shop window mounts. Intentionally not flag-gated and not latched -- closing-and-reopening within a session counts each time -- so it can serve as a session-independent denominator for engagement metrics that span the prefetch-on-join experiment.",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		2026,
		5,
		17
	},
	throttlingPercentage = FIntInExperienceShopTelemetryThrottleHundredthsPercent
}
