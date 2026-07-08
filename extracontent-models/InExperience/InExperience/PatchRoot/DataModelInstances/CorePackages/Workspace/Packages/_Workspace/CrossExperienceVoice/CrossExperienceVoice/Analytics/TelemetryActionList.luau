local Parent = script:FindFirstAncestor("CrossExperienceVoice").Parent
local SupportedTelemetryBackends = require(Parent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("PartyVoiceTelemetryThrottlingThousandths", 1000)
	},
	[EventNames.PartyVoiceStateChanged] = {
		description = "Event when a user transitions state during a party voice session",
		lastUpdated = {
			24,
			12,
			8
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				status = function(p1) -- line: 21
					return p1
				end,
				previousStatus = function(p2) -- line: 24
					return p2
				end,
				detail = function(p3) -- line: 27
					return p3
				end,
				activeDm = function(p4) -- line: 30
					return p4
				end
			}
		}}
	},
	[EventNames.PartyVoiceConnectedParticipantsOnJoin] = {
		description = "Event when a user successfully connects to a party voice channel",
		lastUpdated = {
			24,
			11,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				numberActive = function(p5) -- line: 44
					return p5
				end,
				activeDm = function(p6) -- line: 47
					return p6
				end
			}
		}}
	},
	[EventNames.PartyVoiceJoinFailure] = {
		description = "Event when a user attempts to connect to party voice and results in failure",
		lastUpdated = {
			25,
			3,
			12
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				errorMessage = function(p7) -- line: 61
					return p7
				end
			}
		}}
	},
	[EventNames.PartyVoiceJoinAttempt] = {
		description = "Event when a user attempts to connect to party voice",
		lastUpdated = {
			24,
			12,
			8
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				activeDm = function(p8) -- line: 75
					return p8
				end
			}
		}}
	},
	[EventNames.PartyVoiceUnmuteParticipant] = {
		description = "Event when a user unmutes a participant in party voice",
		lastUpdated = {
			25,
			3,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.PartyVoiceMuteParticipant] = {
		description = "Event when a user mutes a participant in party voice",
		lastUpdated = {
			25,
			3,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.PartyVoiceBlockParticipant] = {
		description = "Event when a user blocks a participant in party voice",
		lastUpdated = {
			25,
			3,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.PartyVoiceUnblockParticipant] = {
		description = "Event when a user unblocks a participant in party voice",
		lastUpdated = {
			25,
			3,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	}
}
