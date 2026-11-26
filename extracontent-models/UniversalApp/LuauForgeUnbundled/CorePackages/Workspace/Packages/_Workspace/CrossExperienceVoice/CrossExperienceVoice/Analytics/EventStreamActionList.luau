local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/Cryo")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/Dash")
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/SocialLuaAnalytics").Analytics.Enums

local contexts = enums.Contexts
local eventTypes = enums.EventTypes

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Analytics/EventNames")

local v5 = { cevJoinAttemptId = Dash.identity, clientTimeStamp = Dash.identity }

return {
	[EventNames.PartyVoiceStateChanged] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceStateChanged,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			userId = Dash.identity,
			partyId = Dash.identity,
			detail = Dash.identity,
			voiceSessionId = Dash.identity,
			voiceChannelId = Dash.identity,
			status = Dash.identity,
			previousStatus = Dash.identity,
			activeDm = Dash.identity
		})
	},
	[EventNames.PartyVoiceJoinAttempt] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceJoinAttempt,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			userId = Dash.identity,
			partyId = Dash.identity,
			targetPlaceId = Dash.identity,
			isConnected = Dash.identity,
			activeDm = Dash.identity
		})
	},
	[EventNames.PartyVoiceJoinFailure] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceJoinFailure,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			userId = Dash.identity,
			partyId = Dash.identity,
			errorMessage = Dash.identity
		})
	},
	[EventNames.PartyVoiceConnectedParticipantsOnJoin] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceConnectedParticipantsOnJoin,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			userId = Dash.identity,
			partyId = Dash.identity,
			status = Dash.identity,
			voiceChannelId = Dash.identity,
			voiceSessionId = Dash.identity,
			voicePlaySessionId = Dash.identity,
			participants = Dash.identity,
			numberActive = Dash.identity,
			activeDm = Dash.identity
		})
	},
	[EventNames.PartyVoiceUnmuteParticipant] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceUnmuteParticipant,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			userId = Dash.identity,
			partyId = Dash.identity
		})
	},
	[EventNames.PartyVoiceMuteParticipant] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceMuteParticipant,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			userId = Dash.identity,
			partyId = Dash.identity
		})
	},
	[EventNames.PartyVoiceBlockParticipant] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceBlockParticipant,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			userId = Dash.identity,
			partyId = Dash.identity
		})
	},
	[EventNames.PartyVoiceUnblockParticipant] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceUnblockParticipant,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			userId = Dash.identity,
			partyId = Dash.identity
		})
	},
	[EventNames.PartyVoiceOnCrossExperienceStartedSignalReceived] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceOnCrossExperienceStartedSignalReceived,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			hasExperienceStarted = Dash.identity,
			isActiveDM = Dash.identity
		})
	},
	[EventNames.PartyVoiceStateChangeHandlerRun] = {
		context = contexts.PartyVoice,
		eventType = eventTypes.PartyVoiceStateChangeHandlerRun,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v5, {
			isActiveDM = Dash.identity,
			status = Dash.identity,
			detail = Dash.identity
		})
	}
}
