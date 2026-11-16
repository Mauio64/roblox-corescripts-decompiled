local parent = script:FindFirstAncestor("NotificationsUpsell").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local ModalEventConstants = require(script.Parent.Parent.ModalEventConstants)

game:DefineFastInt("LuaPushUpsellEventThrottleHundrethsPercent", 10000)

return {
	eventName = ModalEventConstants.OptInPushUpsellEventName,
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("LuaPushUpsellEventThrottleHundrethsPercent"),
	lastUpdated = { 24, 6, 30 },
	description = "Tracks events related to push notifications upsell modal"
}
