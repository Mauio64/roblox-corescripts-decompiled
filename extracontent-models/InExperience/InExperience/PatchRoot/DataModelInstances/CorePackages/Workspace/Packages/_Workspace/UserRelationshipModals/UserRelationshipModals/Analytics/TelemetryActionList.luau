local Parent = script:FindFirstAncestor("UserRelationshipModals").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("UserRelationshipModalsAnalyticsThrottlingThousandths", 10000)
	},
	[EventNames.ModalSeen] = {
		description = "Userrelationshipsmodal was opened",
		lastUpdated = {
			26,
			4,
			16
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			},
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 24
					-- upvalues: EventTypes (copy)
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.UserRelationshipModals,
					placeId = game.PlaceId
				}
			}
		}
	},
	[EventNames.ModalClosed] = {
		description = "User-relationship-modal was closed without changing the user relationship",
		lastUpdated = {
			26,
			4,
			16
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			},
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 43
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					btn = "Close",
					eventContext = Contexts.UserRelationshipModals,
					placeId = game.PlaceId
				}
			}
		}
	},
	[EventNames.CreateActionPressed] = {
		description = "User pressed on the create action button on a user-relationship-modal",
		lastUpdated = {
			26,
			4,
			16
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter
			},
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function() -- line: 63
					-- upvalues: EventTypes (copy)
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					btn = "Create",
					eventContext = Contexts.UserRelationshipModals,
					placeId = game.PlaceId
				}
			}
		}
	}
}
