local parent = script:FindFirstAncestor("SocialBlockingModal").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("SocialBlockingModalAnalyticsThrottlingThousandths", 10000),
		links = ""
	},
	[EventNames.SocialBlockingModalSeen] = {
		description = "Social blocking modal mounted",
		lastUpdated = { 25, 6, 25 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = Contexts.SocialBlockingModal }
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.SocialBlockingModalBlockPressed] = {
		description = "Social blocking modal block button pressed",
		lastUpdated = { 25, 6, 25 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = { eventContext = Contexts.SocialBlockingModal, btn = "Block" }
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.SocialBlockingModalBlockAndReportPressed] = {
		description = "Social blocking modal block and report button pressed",
		lastUpdated = { 25, 6, 25 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.SocialBlockingModal,
					btn = "BlockAndReport"
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.SocialBlockingModalCancelPressed] = {
		description = "Social blocking modal cancel button pressed",
		lastUpdated = { 25, 6, 25 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = { eventContext = Contexts.SocialBlockingModal, btn = "Cancel" }
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	}
}
