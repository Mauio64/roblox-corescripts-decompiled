local Parent = script:FindFirstAncestor("SocialExperienceJoin").Parent
local SupportedTelemetryBackends = require(Parent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("SocialExperienceJoinAnalyticsThrottlingThousandths", 1000)
	},
	[EventNames.JoinExperience] = {
		description = "Join Experience Attempt from other user",
		lastUpdated = {
			24,
			7,
			17
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				status = function(p1) -- line: 20
					return p1
				end
			}
		}}
	},
	[EventNames.PurchaseExperienceAttempt] = {
		description = "Purchase Experience Attempt Status after requesting",
		lastUpdated = {
			24,
			7,
			17
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				status = function(p2) -- line: 34
					return p2
				end
			}
		}}
	},
	[EventNames.PurchaseExperience] = {
		description = "Purchase Experience Button click",
		lastUpdated = {
			24,
			7,
			17
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CancelPurchaseExperience] = {
		description = "Cancel Purchase Experience Attempt from other user",
		lastUpdated = {
			24,
			7,
			17
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.UnableToJoinViewDetails] = {
		description = "Unable to Join Experience View Details",
		lastUpdated = {
			24,
			7,
			17
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.UnableToJoinCancel] = {
		description = "Unable to Join Experience Cancel",
		lastUpdated = {
			24,
			7,
			17
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	}
}
