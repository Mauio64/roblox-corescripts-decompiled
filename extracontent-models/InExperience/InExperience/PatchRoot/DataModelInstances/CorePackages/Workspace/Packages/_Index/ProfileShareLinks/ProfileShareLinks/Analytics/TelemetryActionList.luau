local parent = script:FindFirstAncestor("ProfileShareLinks").Parent

local Dash = require(parent.Dash)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)

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
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = { context = identity, shareType = identity }
			}
		}
	}
}
