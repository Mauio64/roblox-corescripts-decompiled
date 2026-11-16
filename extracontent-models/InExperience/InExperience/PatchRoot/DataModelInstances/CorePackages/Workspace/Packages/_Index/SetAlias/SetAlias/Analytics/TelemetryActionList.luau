local SetAlias = script:FindFirstAncestor("SetAlias")
local EventNames = require(script.Parent.Enums.EventNames)

local parent = SetAlias.Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

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
				type = SupportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = {
					status = function(p)
						return p
					end
				}
			}
		}
	}
}
