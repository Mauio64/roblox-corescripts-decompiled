local Parent = script:FindFirstAncestor("NotificationsUpsell").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local ModalEventConstants = require(script.Parent.Parent.ModalEventConstants)

game:DefineFastInt("LuaPushUpsellEventThrottleHundrethsPercent", 10000)

return {
	description = "Tracks events related to push notifications upsell modal",
	eventName = ModalEventConstants.OptInPushUpsellEventName,
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("LuaPushUpsellEventThrottleHundrethsPercent"),
	lastUpdated = {
		24,
		6,
		30
	}
}
