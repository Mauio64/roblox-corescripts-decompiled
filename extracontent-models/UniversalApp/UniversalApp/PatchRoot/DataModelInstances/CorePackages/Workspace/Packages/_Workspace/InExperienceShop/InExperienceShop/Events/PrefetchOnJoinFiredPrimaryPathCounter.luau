local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local LoggingProtocol = require(InExperienceShopParent.LoggingProtocol)
local FIntInExperienceShopTelemetryThrottleHundredthsPercent = require(InExperienceShop.Flags.FIntInExperienceShopTelemetryThrottleHundredthsPercent)

return {
	eventName = "InExperienceShop_PrefetchOnJoin_Fired_PrimaryPath",
	description = "Counter fired when the join-time prefetch resolves via the primary path (`LocalPlayer.CharacterAppearanceLoaded`). Compared against the fallback-path counter to track which `whenJoinSettles` branch wins the race in the wild and to inform tuning of `FIntShopFetchOnGameJoinFallbackDelayMs`.",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		2026,
		5,
		17
	},
	throttlingPercentage = FIntInExperienceShopTelemetryThrottleHundredthsPercent
}
