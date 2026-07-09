local Parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local Dash = require(Parent.Dash)
local SupportedTelemetryBackends = require(Parent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)
local identity = Dash.identity

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("ProfileShareLinksAnalyticsThrottlingThousandths", 1000)
	},
	[EventNames.ProfileShareLinkActivated] = {
		description = "Profile share link button activated",
		lastUpdated = {
			24,
			6,
			11
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				context = identity,
				shareType = identity
			}
		}}
	}
}
