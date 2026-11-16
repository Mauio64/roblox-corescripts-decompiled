local parent = script:FindFirstAncestor("InExperienceShop").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

return {
	eventName = "InExperienceShop_GlobalIconClick",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	lastUpdated = { 2026, 7, 6 },
	throttlingPercentage = 10000,
	description = "EventIngest event fired when the in-experience shop global top-bar icon is clicked.",
	links = ""
}
