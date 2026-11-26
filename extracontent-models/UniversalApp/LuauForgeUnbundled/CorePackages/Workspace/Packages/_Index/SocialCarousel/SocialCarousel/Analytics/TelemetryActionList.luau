local supportedTelemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialLuaAnalytics").Analytics.Enums.SupportedTelemetryBackends
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/EventNames")
local fFlagSocialCarouselShareQREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselShareQREnabled

local FFlagSocialCarouselLogNewFriendRequestsBadge = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselLogNewFriendRequestsBadge")

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("SocialCarouselAnalyticsThrottlingThousandths", 10000),
		links = ""
	},
	[EventNames.UserPressed] = {
		description = "User pressed on a user tile",
		lastUpdated = { 25, 4, 14 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.UserSeen] = {
		description = "User has seen an user tile",
		lastUpdated = { 25, 4, 14 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ViewAddFriends] = {
		description = "User pressed on the add friends tile",
		lastUpdated = { 25, 4, 21 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.AddFriendsTileSeen] = FFlagSocialCarouselLogNewFriendRequestsBadge and {
		description = "New-friend-request badge count resolved or changed on the Home Add Friends tile",
		lastUpdated = { 26, 10, 29 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.ViewAllFriends] = {
		description = "User pressed on the carousel header",
		lastUpdated = { 25, 4, 21 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.StartSquadPressed] = {
		description = "User pressed on the start squad tile",
		lastUpdated = { 25, 11, 11 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ShareQRPressed] = fFlagSocialCarouselShareQREnabled and {
		description = "User pressed on the share QR tile",
		lastUpdated = { 26, 4, 14 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil
}
