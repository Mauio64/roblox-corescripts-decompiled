local Parent = script:FindFirstAncestor("SocialCarousel").Parent
local SupportedTelemetryBackends = require(Parent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)
local FFlagSocialCarouselShareQREnabled = require(Parent.SharedFlags).FFlagSocialCarouselShareQREnabled

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("SocialCarouselAnalyticsThrottlingThousandths", 10000)
	},
	[EventNames.UserPressed] = {
		description = "User pressed on a user tile",
		lastUpdated = {
			25,
			4,
			14
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.UserSeen] = {
		description = "User has seen an user tile",
		lastUpdated = {
			25,
			4,
			14
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ViewAddFriends] = {
		description = "User pressed on the add friends tile",
		lastUpdated = {
			25,
			4,
			21
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ViewAllFriends] = {
		description = "User pressed on the carousel header",
		lastUpdated = {
			25,
			4,
			21
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.StartSquadPressed] = {
		description = "User pressed on the start squad tile",
		lastUpdated = {
			25,
			11,
			11
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ShareQRPressed] = if not FFlagSocialCarouselShareQREnabled then nil else {
		description = "User pressed on the share QR tile",
		lastUpdated = {
			26,
			4,
			14
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	}
}
