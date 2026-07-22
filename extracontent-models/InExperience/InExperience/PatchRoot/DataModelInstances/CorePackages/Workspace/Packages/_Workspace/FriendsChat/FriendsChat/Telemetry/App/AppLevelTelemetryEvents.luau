local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Telemetry = require(Parent.AppChat.Telemetry)
local DefaultTelemetryEvents = require(Parent.AppChat.DefaultTelemetryEvents)

return {
	AppChatVisible = Telemetry.new({
		name = "appChatVisible",
		description = "",
		lastUpdated = {
			2026,
			7,
			7
		},
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationAndFormat("AppChat.Navigation.Visible", function(t1: {[any]: any}) -- line: 27
				return {
					isChatEnabled = t1.isChatEnabled
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t2: {[any]: any}) -- line: 33
				return {
					isChatEnabled = t2.isChatEnabled
				}
			end)
		}
	}),
	AppChatClosed = Telemetry.new({
		name = "appChatClosed",
		description = "",
		lastUpdated = {
			2026,
			7,
			7
		},
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationAndFormat("AppChat.Navigation.Closed", function(t3: {[any]: any}) -- line: 47
				return {
					isChatEnabled = t3.isChatEnabled
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t4: {[any]: any}) -- line: 53
				return {
					isChatEnabled = t4.isChatEnabled
				}
			end)
		}
	})
}
