local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")

require(SocialLuaAnalytics.Analytics.Types)

local SupportedTelemetryBackends = require(SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends)
local Contexts = require(SocialLuaAnalytics.Analytics.Enums.Contexts)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("ExampleSLATelemetryThrottlingThousandths", 800)
	},
	PageLoad = {
		description = "QR code page load",
		lastUpdated = {
			24,
			5,
			9
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	PageLoadWithCustomIncrement = {
		description = "QR code page load",
		lastUpdated = {
			24,
			5,
			9
		},
		backendsList = {{
			incrementValue = 2,
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				successStatus = function(p1) -- line: 28
					return p1
				end
			},
			staticCustomFields = {
				ctx = Contexts.Party
			}
		}},
		eventStreamCtx = Contexts.Party
	},
	PageLoadWithDynamicName = {
		description = "Test for dynamic name",
		lastUpdated = {
			24,
			5,
			9
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			overrideName = function(p2) -- line: 45
				return "PageLoadWithDynamicName" .. p2.successStatus
			end
		}}
	},
	SimplePageLoadTimer = {
		description = "QR code page load timer",
		lastUpdated = {
			24,
			5,
			9
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat
		}}
	},
	ComplexPageLoadTimer = {
		description = "QR code page load timer",
		lastUpdated = {
			24,
			5,
			9
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat,
			dynamicCustomFields = {
				successStatus = function(p3) -- line: 67
					return p3
				end
			},
			staticCustomFields = {
				ctx = Contexts.Party
			}
		}},
		eventStreamCtx = Contexts.Party
	}
}
