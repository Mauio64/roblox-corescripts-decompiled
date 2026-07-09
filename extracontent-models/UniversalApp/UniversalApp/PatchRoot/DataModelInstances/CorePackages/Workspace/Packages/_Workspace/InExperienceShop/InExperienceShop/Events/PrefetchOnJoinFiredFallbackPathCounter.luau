local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local LoggingProtocol = require(InExperienceShopParent.LoggingProtocol)
local FIntInExperienceShopTelemetryThrottleHundredthsPercent = require(InExperienceShop.Flags.FIntInExperienceShopTelemetryThrottleHundredthsPercent)

return {
	eventName = "InExperienceShop_PrefetchOnJoin_Fired_FallbackPath",
	description = "Counter fired when the join-time prefetch resolves via the `game.Loaded` + `FIntShopFetchOnGameJoinFallbackDelayMs` fallback path -- i.e. experiences that disable `Players.CharacterAutoLoads` or otherwise never fire `CharacterAppearanceLoaded`. Compared against the primary-path counter to inform fallback-delay tuning.",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		2026,
		5,
		17
	},
	throttlingPercentage = FIntInExperienceShopTelemetryThrottleHundredthsPercent
}
