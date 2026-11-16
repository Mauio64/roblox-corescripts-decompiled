local supportedTelemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SocialLuaAnalytics").Analytics.Enums.SupportedTelemetryBackends
local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SharedFlags").FFlagJoinabilityCTARefactor
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/EventNames")

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt(
			"SocialExperienceJoinAnalyticsThrottlingThousandths",
			1000
		),
		links = ""
	},
	[EventNames.JoinExperience] = {
		description = "Experience launch attempt from another user's presence; followUser differentiates Join from Play.",
		lastUpdated = { 26, 10, 5 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					status = function(p2)
						return p2
					end,
					followUser = fFlagJoinabilityCTARefactor and function(p2)
						return p2
					end or nil
				}
			}
		}
	},
	[EventNames.PurchaseExperienceAttempt] = {
		description = "Purchase Experience Attempt Status after requesting",
		lastUpdated = { 24, 7, 17 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					status = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.PurchaseExperience] = {
		description = "Purchase Experience Button click",
		lastUpdated = { 24, 7, 17 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CancelPurchaseExperience] = {
		description = "Cancel Purchase Experience Attempt from other user",
		lastUpdated = { 24, 7, 17 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.UnableToJoinViewDetails] = {
		description = "Unable to Join Experience View Details",
		lastUpdated = { 24, 7, 17 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.UnableToJoinCancel] = {
		description = "Unable to Join Experience Cancel",
		lastUpdated = { 24, 7, 17 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	}
}
