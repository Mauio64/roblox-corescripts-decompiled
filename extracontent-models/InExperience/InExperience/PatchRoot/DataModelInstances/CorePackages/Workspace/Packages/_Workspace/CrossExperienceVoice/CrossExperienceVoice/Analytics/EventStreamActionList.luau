local parent = script:FindFirstAncestor("CrossExperienceVoice").Parent

local Cryo = require(parent.Cryo)
local Dash = require(parent.Dash)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Enums = SocialLuaAnalytics.Analytics.Enums

local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes

local EventNames = require(script.Parent.EventNames)

local v = { cevJoinAttemptId = Dash.identity, clientTimeStamp = Dash.identity }

return {
	[EventNames.PartyVoiceStateChanged] = {
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceStateChanged,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
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
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceJoinAttempt,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
			userId = Dash.identity,
			partyId = Dash.identity,
			targetPlaceId = Dash.identity,
			isConnected = Dash.identity,
			activeDm = Dash.identity
		})
	},
	[EventNames.PartyVoiceJoinFailure] = {
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceJoinFailure,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
			userId = Dash.identity,
			partyId = Dash.identity,
			errorMessage = Dash.identity
		})
	},
	[EventNames.PartyVoiceConnectedParticipantsOnJoin] = {
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceConnectedParticipantsOnJoin,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
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
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceUnmuteParticipant,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
			userId = Dash.identity,
			partyId = Dash.identity
		})
	},
	[EventNames.PartyVoiceMuteParticipant] = {
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceMuteParticipant,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
			userId = Dash.identity,
			partyId = Dash.identity
		})
	},
	[EventNames.PartyVoiceBlockParticipant] = {
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceBlockParticipant,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
			userId = Dash.identity,
			partyId = Dash.identity
		})
	},
	[EventNames.PartyVoiceUnblockParticipant] = {
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceUnblockParticipant,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
			userId = Dash.identity,
			partyId = Dash.identity
		})
	},
	[EventNames.PartyVoiceOnCrossExperienceStartedSignalReceived] = {
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceOnCrossExperienceStartedSignalReceived,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
			hasExperienceStarted = Dash.identity,
			isActiveDM = Dash.identity
		})
	},
	[EventNames.PartyVoiceStateChangeHandlerRun] = {
		context = Contexts.PartyVoice,
		eventType = EventTypes.PartyVoiceStateChangeHandlerRun,
		formatRulesForAdditionalInfo = Cryo.Dictionary.union(v, {
			isActiveDM = Dash.identity,
			status = Dash.identity,
			detail = Dash.identity
		})
	}
}
