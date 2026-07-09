local SetAlias = script:FindFirstAncestor("SetAlias")
local EventNames = require(script.Parent.Enums.EventNames)
local SetAliasParent = SetAlias.Parent
local SupportedTelemetryBackends = require(SetAliasParent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("SetAliasAnalyticsThrottlingThousandths", 1000)
	},
	[EventNames.CustomizeNameLoadingStage] = {
		description = "Set Alias View Opened",
		lastUpdated = {
			24,
			6,
			10
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat,
			dynamicCustomFields = {
				status = function(p1) -- line: 20
					return p1
				end
			}
		}}
	}
}
