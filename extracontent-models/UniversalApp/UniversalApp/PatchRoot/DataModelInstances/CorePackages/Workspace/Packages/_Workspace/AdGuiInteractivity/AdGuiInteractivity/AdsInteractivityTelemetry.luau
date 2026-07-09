local ParentParent = script.Parent.Parent
local LoggingProtocol = require(ParentParent.LoggingProtocol)
local default = LoggingProtocol.default
local t1 = {
	eventName = "AdMenuEvent",
	description = "        This event is fired when a user interacts with the ad menu.\n    ",
	links = "https://roblox.atlassian.net/browse/ADS-6383",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		24,
		10,
		29
	}
}
local t2 = {
	eventName = "WhyThisAdEvent",
	description = "        This event is fired when a user interacts with the \"Why this ad?\" button.\n    ",
	links = "https://roblox.atlassian.net/browse/ADS-6383",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		24,
		10,
		29
	}
}
local t3 = {
	eventName = "ReportAdEvent",
	description = "        This event is fired when a user interacts with the \"Report this ad\" button.\n    ",
	links = "https://roblox.atlassian.net/browse/ADS-6383",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		24,
		10,
		29
	}
}
local t4 = {
	eventName = "ImmersiveBrandedAdButtonClickEvent",
	description = "This event is fired when a user clicks one of the immersive branded ad buttons (disclosure, \"Why this ad?\", or \"Report this ad\").",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		26,
		3,
		11
	}
}
local t5 = {
	eventName = "ImmersiveBrandedAdLinkingFailedEvent",
	description = "This event is fired when a user tries to click one of the immersive branded ad menu/dialog links, but LinkingProtocol fails.",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		26,
		3,
		24
	}
}

return {
	logAdMenuEvent = function(s1: string) -- line: 72
		-- upvalues: default (copy), t1 (copy)
		default:logRobloxTelemetryCounter(t1, 1, {
			state = s1
		})
	end,
	logWhyThisAdEvent = function() -- line: 78
		-- upvalues: default (copy), t2 (copy)
		default:logRobloxTelemetryCounter(t2, 1)
	end,
	logReportAdEvent = function(s2: string) -- line: 88
		-- upvalues: default (copy), t3 (copy)
		default:logRobloxTelemetryCounter(t3, 1, {
			state = s2
		})
	end,
	logImmersiveBrandedAdButtonClickCounter = function(s3: string) -- line: 94
		-- upvalues: default (copy), t4 (copy)
		default:logRobloxTelemetryCounter(t4, 1, {
			buttonName = s3
		})
	end,
	logImmersiveBrandedAdLinkingFailedCounter = function(s4: string) -- line: 102
		-- upvalues: default (copy), t5 (copy)
		default:logRobloxTelemetryCounter(t5, 1, {
			linkName = s4
		})
	end
}
