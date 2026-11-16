local parent = script:FindFirstAncestor("CrossExperienceVoice").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

local EventNames = require(script.Parent.EventNames)

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
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					status = function(p)
						return p
					end,
					previousStatus = function(p)
						return p
					end,
					detail = function(p)
						return p
					end,
					activeDm = function(p)
						return p
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
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					numberActive = function(p)
						return p
					end,
					activeDm = function(p)
						return p
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
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					errorMessage = function(p)
						return p
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
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					activeDm = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.PartyVoiceUnmuteParticipant] = {
		lastUpdated = { 25, 3, 30 },
		description = "Event when a user unmutes a participant in party voice",
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.PartyVoiceMuteParticipant] = {
		lastUpdated = { 25, 3, 30 },
		description = "Event when a user mutes a participant in party voice",
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.PartyVoiceBlockParticipant] = {
		lastUpdated = { 25, 3, 30 },
		description = "Event when a user blocks a participant in party voice",
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.PartyVoiceUnblockParticipant] = {
		lastUpdated = { 25, 3, 30 },
		description = "Event when a user unblocks a participant in party voice",
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	}
}
