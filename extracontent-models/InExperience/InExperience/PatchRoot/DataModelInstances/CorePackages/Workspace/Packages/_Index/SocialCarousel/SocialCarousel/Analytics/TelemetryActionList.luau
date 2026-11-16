local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled

local FFlagSocialCarouselLogNewFriendRequestsBadge = require(SocialCarousel.Flags.FFlagSocialCarouselLogNewFriendRequestsBadge)

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("SocialCarouselAnalyticsThrottlingThousandths", 10000),
		links = ""
	},
	[EventNames.UserPressed] = {
		description = "User pressed on a user tile",
		lastUpdated = { 25, 4, 14 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.UserSeen] = {
		description = "User has seen an user tile",
		lastUpdated = { 25, 4, 14 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ViewAddFriends] = {
		description = "User pressed on the add friends tile",
		lastUpdated = { 25, 4, 21 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.AddFriendsTileSeen] = FFlagSocialCarouselLogNewFriendRequestsBadge and {
		description = "New-friend-request badge count resolved or changed on the Home Add Friends tile",
		lastUpdated = { 26, 10, 29 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.ViewAllFriends] = {
		description = "User pressed on the carousel header",
		lastUpdated = { 25, 4, 21 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.StartSquadPressed] = {
		description = "User pressed on the start squad tile",
		lastUpdated = { 25, 11, 11 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ShareQRPressed] = FFlagSocialCarouselShareQREnabled and {
		description = "User pressed on the share QR tile",
		lastUpdated = { 26, 4, 14 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil
}
