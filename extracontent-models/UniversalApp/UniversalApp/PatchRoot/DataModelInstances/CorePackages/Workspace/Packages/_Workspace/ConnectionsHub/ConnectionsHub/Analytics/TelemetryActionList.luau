local Parent = script:FindFirstAncestor("ConnectionsHub").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("CoHubAnalyticsThrottlingThousandths", 10000)
	},
	[EventNames.CoHubTabClicked] = {
		description = "CoHub tab clicked",
		lastUpdated = {
			26,
			1,
			27
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 22
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.ConnectionsHub
				},
				dynamicCustomFields = {
					btn = function(p1) -- line: 29
						return "tabId_" .. p1
					end,
					subpage = function(p2) -- line: 32
						return "tabId_" .. p2
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					btn = function(p3) -- line: 40
						return p3
					end,
					subpage = function(p4) -- line: 43
						return p4
					end
				}
			}
		}
	}
}
