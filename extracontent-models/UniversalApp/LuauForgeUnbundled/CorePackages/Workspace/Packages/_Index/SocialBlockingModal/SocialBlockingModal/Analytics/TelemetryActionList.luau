local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/SocialLuaAnalytics")
local supportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local eventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/SocialBlockingModal/Analytics/EventNames")

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt(
			"SocialBlockingModalAnalyticsThrottlingThousandths",
			10000
		),
		links = ""
	},
	[EventNames.SocialBlockingModalSeen] = {
		description = "Social blocking modal mounted",
		lastUpdated = { 25, 6, 25 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.UserSeen
				end,
				staticCustomFields = { eventContext = contexts.SocialBlockingModal }
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.SocialBlockingModalBlockPressed] = {
		description = "Social blocking modal block button pressed",
		lastUpdated = { 25, 6, 25 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.SocialBlockingModal,
					btn = "Block"
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.SocialBlockingModalBlockAndReportPressed] = {
		description = "Social blocking modal block and report button pressed",
		lastUpdated = { 25, 6, 25 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.SocialBlockingModal,
					btn = "BlockAndReport"
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.SocialBlockingModalCancelPressed] = {
		description = "Social blocking modal cancel button pressed",
		lastUpdated = { 25, 6, 25 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = contexts.SocialBlockingModal,
					btn = "Cancel"
				}
			},
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	}
}
