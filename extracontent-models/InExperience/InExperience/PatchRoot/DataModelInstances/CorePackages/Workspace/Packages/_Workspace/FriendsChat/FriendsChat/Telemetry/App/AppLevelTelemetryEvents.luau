local parent = script:FindFirstAncestor("FriendsChat").Parent

local Telemetry = require(parent.AppChat.Telemetry)
local DefaultTelemetryEvents = require(parent.AppChat.DefaultTelemetryEvents)

return {
	AppChatVisible = Telemetry.new({
		name = "appChatVisible",
		description = "",
		lastUpdated = { 2026, 10, 7 },
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationAndFormat("AppChat.Navigation.Visible", function(data)
				return {
					isChatEnabled = data.isChatEnabled,
					isChatLoading = data.isChatLoading,
					isInConversation = data.isInConversation
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p)
				return { isChatEnabled = p.isChatEnabled, isChatLoading = p.isChatLoading }
			end)
		}
	}),
	AppChatClosed = Telemetry.new({
		name = "appChatClosed",
		description = "",
		lastUpdated = { 2026, 7, 7 },
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationAndFormat("AppChat.Navigation.Closed", function(p)
				return { isChatEnabled = p.isChatEnabled, isChatLoading = p.isChatLoading }
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p)
				return { isChatEnabled = p.isChatEnabled, isChatLoading = p.isChatLoading }
			end)
		}
	})
}
