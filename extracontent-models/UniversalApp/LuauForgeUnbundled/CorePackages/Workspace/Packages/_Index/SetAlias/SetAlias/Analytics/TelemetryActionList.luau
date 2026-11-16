local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/Enums/EventNames")

local supportedTelemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/SocialLuaAnalytics").Analytics.Enums.SupportedTelemetryBackends

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("SetAliasAnalyticsThrottlingThousandths", 1000),
		links = ""
	},
	[EventNames.CustomizeNameLoadingStage] = {
		description = "Set Alias View Opened",
		lastUpdated = { 24, 6, 10 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = {
					status = function(p2)
						return p2
					end
				}
			}
		}
	}
}
