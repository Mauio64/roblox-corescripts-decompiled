local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return {
	eventName = "InExperienceShop_GlobalIconClick",
	throttlingPercentage = 10000,
	description = "EventIngest event fired when the in-experience shop global top-bar icon is clicked.",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	lastUpdated = {
		2026,
		7,
		6
	}
}
