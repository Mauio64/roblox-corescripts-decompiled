local Parent = script:FindFirstAncestor("SocialBlockingModal").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("SocialBlockingModalAnalyticsThrottlingThousandths", 10000)
	},
	[EventNames.SocialBlockingModalSeen] = {
		description = "Social blocking modal mounted",
		lastUpdated = {
			25,
			6,
			25
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 22
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.SocialBlockingModal
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.SocialBlockingModalBlockPressed] = {
		description = "Social blocking modal block button pressed",
		lastUpdated = {
			25,
			6,
			25
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 40
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					btn = "Block",
					eventContext = Contexts.SocialBlockingModal
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.SocialBlockingModalBlockAndReportPressed] = {
		description = "Social blocking modal block and report button pressed",
		lastUpdated = {
			25,
			6,
			25
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 59
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					btn = "BlockAndReport",
					eventContext = Contexts.SocialBlockingModal
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	},
	[EventNames.SocialBlockingModalCancelPressed] = {
		description = "Social blocking modal cancel button pressed",
		lastUpdated = {
			25,
			6,
			25
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 78
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					btn = "Cancel",
					eventContext = Contexts.SocialBlockingModal
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			}
		}
	}
}
