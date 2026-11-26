local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/LoggingProtocol")
local ModalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/ModalEventConstants")

game:DefineFastInt("LuaPushUpsellEventThrottleHundrethsPercent", 10000)

return {
	eventName = ModalEventConstants.OptInPushUpsellEventName,
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("LuaPushUpsellEventThrottleHundrethsPercent"),
	lastUpdated = { 24, 6, 30 },
	description = "Tracks events related to push notifications upsell modal"
}
