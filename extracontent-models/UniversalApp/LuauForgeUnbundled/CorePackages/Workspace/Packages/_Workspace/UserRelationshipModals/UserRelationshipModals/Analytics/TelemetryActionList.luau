local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/SocialLuaAnalytics")
local supportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local eventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/UserRelationshipModals/Analytics/EventNames")

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("CoHubAnalyticsThrottlingThousandths", 10000),
		links = ""
	},
	[EventNames.CoHubTabClicked] = {
		description = "CoHub tab clicked",
		lastUpdated = { 26, 1, 27 },
		backendsList = {
			{
				type = supportedTelemetryBackends.EventIngest,
				overrideName = function()
					return eventTypes.ButtonClick
				end,
				staticCustomFields = { eventContext = contexts.ConnectionsHub },
				dynamicCustomFields = {
					btn = function(p2)
						return "tabId_" .. p2
					end,
					subpage = function(p2)
						return "tabId_" .. p2
					end
				}
			},
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					btn = function(p2)
						return p2
					end,
					subpage = function(p2)
						return p2
					end
				}
			}
		}
	}
}
