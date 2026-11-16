local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/Dash")
local supportedTelemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/SocialLuaAnalytics").Analytics.Enums.SupportedTelemetryBackends
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Analytics/EventNames")

local identity = Dash.identity

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("ProfileShareLinksAnalyticsThrottlingThousandths", 1000),
		links = ""
	},
	[EventNames.ProfileShareLinkActivated] = {
		description = "Profile share link button activated",
		lastUpdated = { 24, 6, 11 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = { context = identity, shareType = identity }
			}
		}
	}
}
