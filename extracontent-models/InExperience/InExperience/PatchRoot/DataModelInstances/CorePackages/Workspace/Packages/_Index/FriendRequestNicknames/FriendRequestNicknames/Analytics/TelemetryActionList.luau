local Parent = script:FindFirstAncestor("FriendRequestNicknames").Parent
local SupportedTelemetryBackends = require(Parent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("FriendRequestNicknamesTelemetryThrottlingThousandths", 1000)
	},
	[EventNames.SetNicknameModalOpened] = {
		description = "Friend Request Nicknames modal opened",
		lastUpdated = {
			24,
			8,
			7
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.SetNicknameSkipClicked] = {
		description = "Friend Request Nicknames modal clicked skip",
		lastUpdated = {
			24,
			8,
			7
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.SetNicknameAddNameClicked] = {
		description = "Friend Request Nicknames modal clicked add name",
		lastUpdated = {
			24,
			8,
			7
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	}
}
