local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local LoggingProtocol = require(InExperienceShopParent.LoggingProtocol)
local FIntInExperienceShopTelemetryThrottleHundredthsPercent = require(InExperienceShop.Flags.FIntInExperienceShopTelemetryThrottleHundredthsPercent)

return {
	eventName = "InExperienceShop_FirstOpen_PrefetchHit",
	description = "Counter fired alongside `InExperienceShop_FirstOpen` when categories are already populated at first-open time -- i.e. the join-time prefetch landed before the user opened the shop. Acts as the numerator for the prefetch-hit-rate metric. Both numerator and denominator emit from the same effect invocation so the at-query-time ratio stays in sync.",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		2026,
		5,
		17
	},
	throttlingPercentage = FIntInExperienceShopTelemetryThrottleHundredthsPercent
}
