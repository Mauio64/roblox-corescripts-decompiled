local parent = script.Parent.Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local default = LoggingProtocol.default

local v = {
	eventName = "AdMenuEvent",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 24, 10, 29 },
	description = "        This event is fired when a user interacts with the ad menu.\n    ",
	links = "https://roblox.atlassian.net/browse/ADS-6383"
}

local v2 = {
	eventName = "WhyThisAdEvent",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 24, 10, 29 },
	description = "        This event is fired when a user interacts with the \"Why this ad?\" button.\n    ",
	links = "https://roblox.atlassian.net/browse/ADS-6383"
}

local v3 = {
	eventName = "ReportAdEvent",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 24, 10, 29 },
	description = "        This event is fired when a user interacts with the \"Report this ad\" button.\n    ",
	links = "https://roblox.atlassian.net/browse/ADS-6383"
}

local v4 = {
	eventName = "ImmersiveBrandedAdButtonClickEvent",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 26, 3, 11 },
	description = "This event is fired when a user clicks one of the immersive branded ad buttons (disclosure, \"Why this ad?\", or \"Report this ad\").",
	links = ""
}

local v5 = {
	eventName = "ImmersiveBrandedAdLinkingFailedEvent",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 26, 3, 24 },
	description = "This event is fired when a user tries to click one of the immersive branded ad menu/dialog links, but LinkingProtocol fails.",
	links = ""
}
local AdsInteractivityTelemetry = {}

function AdsInteractivityTelemetry.logAdMenuEvent(state: string)
	default:logRobloxTelemetryCounter(v, 1, { state = state })
end

function AdsInteractivityTelemetry.logWhyThisAdEvent()
	default:logRobloxTelemetryCounter(v2, 1)
end

function AdsInteractivityTelemetry.logReportAdEvent(state: string)
	default:logRobloxTelemetryCounter(v3, 1, { state = state })
end

function AdsInteractivityTelemetry.logImmersiveBrandedAdButtonClickCounter(buttonName: string)
	default:logRobloxTelemetryCounter(v4, 1, { buttonName = buttonName })
end

function AdsInteractivityTelemetry.logImmersiveBrandedAdLinkingFailedCounter(linkName: string)
	default:logRobloxTelemetryCounter(v5, 1, { linkName = linkName })
end

return AdsInteractivityTelemetry
