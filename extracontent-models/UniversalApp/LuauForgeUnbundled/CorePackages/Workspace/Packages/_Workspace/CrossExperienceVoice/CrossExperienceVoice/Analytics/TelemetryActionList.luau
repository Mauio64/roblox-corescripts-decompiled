local supportedTelemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/SocialLuaAnalytics").Analytics.Enums.SupportedTelemetryBackends

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Analytics/EventNames")

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("PartyVoiceTelemetryThrottlingThousandths", 1000),
		links = ""
	},
	[EventNames.PartyVoiceStateChanged] = {
		lastUpdated = { 24, 12, 8 },
		description = "Event when a user transitions state during a party voice session",
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					status = function(p2)
						return p2
					end,
					previousStatus = function(p2)
						return p2
					end,
					detail = function(p2)
						return p2
					end,
					activeDm = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.PartyVoiceConnectedParticipantsOnJoin] = {
		lastUpdated = { 24, 11, 30 },
		description = "Event when a user successfully connects to a party voice channel",
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					numberActive = function(p2)
						return p2
					end,
					activeDm = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.PartyVoiceJoinFailure] = {
		lastUpdated = { 25, 3, 12 },
		description = "Event when a user attempts to connect to party voice and results in failure",
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					errorMessage = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.PartyVoiceJoinAttempt] = {
		lastUpdated = { 24, 12, 8 },
		description = "Event when a user attempts to connect to party voice",
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					activeDm = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.PartyVoiceUnmuteParticipant] = {
		lastUpdated = { 25, 3, 30 },
		description = "Event when a user unmutes a participant in party voice",
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.PartyVoiceMuteParticipant] = {
		lastUpdated = { 25, 3, 30 },
		description = "Event when a user mutes a participant in party voice",
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.PartyVoiceBlockParticipant] = {
		lastUpdated = { 25, 3, 30 },
		description = "Event when a user blocks a participant in party voice",
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.PartyVoiceUnblockParticipant] = {
		lastUpdated = { 25, 3, 30 },
		description = "Event when a user unblocks a participant in party voice",
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	}
}
