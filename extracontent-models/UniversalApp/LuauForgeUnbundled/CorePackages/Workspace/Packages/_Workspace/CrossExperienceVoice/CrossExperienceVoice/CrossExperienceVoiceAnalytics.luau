local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")
local Players = game:GetService("Players")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Analytics")
local Flags = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Flags")
local loggingProtocol = dependencies.LoggingProtocol

local crossExperience = dependencies.CrossExperience
local getMemStorageKey = crossExperience.Utils.getMemStorageKey

local class = {}
class.__index = class

local CEV_JOIN_ATTEMPT_ID_KEY = crossExperience.Constants.CEV_JOIN_ATTEMPT_ID_KEY

function class.new()
	local v5 = {
		previousStatus = nil,
		connections = {},
		isInitialized = false,
		eventManager = nil,
		analytics = Analytics.Analytics()
	}

	setmetatable(v5, class)
	return v5
end

function class:initialize(eventManager)
	self.eventManager = eventManager
	self.isInitialized = true
end

function class:fireCEVAnalyticsEvent(p3, options)
	local v5 = options or {}
	v5.cevJoinAttemptId = getMemStorageKey(CEV_JOIN_ATTEMPT_ID_KEY)
	v5.clientTimeStamp = os.time()
	self.analytics.fireAnalyticsEvent(p3, v5)
end

function class:logPartyVoiceTimeout(value)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChanged, {
		partyId = value or "",
		status = crossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT,
		previousStatus = self.previousStatus or "",
		userId = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId
	})
end

function class:logPartyVoiceStatusChanged(data, value, value2)
	if not self.isInitialized then
		return
	end

	if self.previousStatus ~= data.status then
		if Flags.FFlagEnablePartyVoiceStatusChangedDetailAnalytics then
			if Flags.FFlagPartyVoiceLogActiveDM then
				self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChanged, {
					partyId = value or "",
					status = data.status,
					detail = data.detail or "",
					previousStatus = self.previousStatus or "",
					voiceChannelId = data.voiceChannelId,
					voiceSessionId = data.voiceSessionId,
					userId = data.userId,
					activeDm = value2 or ""
				})
			else
				self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChanged, {
					partyId = value or "",
					status = data.status,
					detail = data.detail or "",
					previousStatus = self.previousStatus or "",
					voiceChannelId = data.voiceChannelId,
					voiceSessionId = data.voiceSessionId,
					userId = data.userId,
					activeDm = ""
				})
			end
		else
			self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChanged, {
				partyId = value or "",
				status = data.status,
				previousStatus = self.previousStatus or "",
				voiceChannelId = data.voiceChannelId,
				voiceSessionId = data.voiceSessionId,
				userId = data.userId
			})
		end
	end

	self.previousStatus = data.status
end

function class:logPartyVoiceConnectedState(data, value, value2)
	if not self.isInitialized then
		return
	end

	if Flags.FFlagPartyVoiceLogActiveDM then
		self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceConnectedParticipantsOnJoin, {
			userId = not data.userId and 0 or data.userId,
			partyId = value or "",
			status = not data.status and "" or data.status,
			voiceChannelId = not data.voiceChannelId and "" or data.voiceChannelId,
			voiceSessionId = not data.voiceSessionId and "" or data.voiceSessionId,
			voicePlaySessionId = not data.voicePlaySessionId and "" or data.voicePlaySessionId,
			participants = not data.participants and "" or data.participants,
			numberActive = data.numberActive or 0,
			activeDm = value2 or ""
		})
	else
		self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceConnectedParticipantsOnJoin, {
			userId = not data.userId and 0 or data.userId,
			partyId = value or "",
			status = not data.status and "" or data.status,
			voiceChannelId = not data.voiceChannelId and "" or data.voiceChannelId,
			voiceSessionId = not data.voiceSessionId and "" or data.voiceSessionId,
			voicePlaySessionId = not data.voicePlaySessionId and "" or data.voicePlaySessionId,
			participants = not data.participants and "" or data.participants,
			numberActive = data.numberActive or 0,
			activeDm = ""
		})
	end

	self:logLaunchFlowEndEvent()
end

function class:logPartyVoiceJoinAttempt(data)
	if not self.isInitialized then
		return
	end

	if Flags.FFlagPartyVoiceLogActiveDM then
		local partyVoiceJoinAttempt = Analytics.EventNames.PartyVoiceJoinAttempt
		local v5 = {
			userId = not data.userId and 0 or data.userId,
			partyId = not data.partyId and "" or data.partyId,
			targetPlaceId = not data.targetPlaceId and 0 or data.targetPlaceId,
			isConnected = 0,
			activeDm = 0
		}
		local v6 = if data.isConnected then data.isConnected else false
		v5.isConnected = v6
		v5.activeDm = not data.activeDm and "" or data.activeDm
		self:fireCEVAnalyticsEvent(partyVoiceJoinAttempt, v5)
	else
		local partyVoiceJoinAttempt = Analytics.EventNames.PartyVoiceJoinAttempt
		local v5 = {
			userId = not data.userId and 0 or data.userId,
			partyId = not data.partyId and "" or data.partyId,
			targetPlaceId = not data.targetPlaceId and 0 or data.targetPlaceId,
			isConnected = 0,
			activeDm = ""
		}
		local v6 = if data.isConnected then data.isConnected else false
		v5.isConnected = v6
		self:fireCEVAnalyticsEvent(partyVoiceJoinAttempt, v5)
	end

	self:logLaunchFlowBeginEvent()
end

function class:logLaunchFlowBeginEvent()
	loggingProtocol.default:logEvent("party_voice_launch_flow_begin")
end

function class:logLaunchFlowEndEvent()
	loggingProtocol.default:logEvent("party_voice_launch_flow_end")
end

function class:logPartyVoiceJoinFailure(p2, value, value2)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceJoinFailure, {
		partyId = p2,
		errorMessage = value or "",
		userId = value2 or 0
	})
end

function class:logPartyVoiceUnmuteParticipant(p2, value)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceUnmuteParticipant, {
		partyId = p2,
		userId = value or 0
	})
end

function class:logPartyVoiceMuteParticipant(p2, value)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceMuteParticipant, {
		partyId = p2,
		userId = value or 0
	})
end

function class:logPartyVoiceBlockParticipant(p2, value)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceBlockParticipant, {
		partyId = p2,
		userId = value or 0
	})
end

function class:logPartyVoiceUnblockParticipant(p2, value)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceUnblockParticipant, {
		partyId = p2,
		userId = value or 0
	})
end

function class:logPartyVoiceOnCrossExperienceStartedSignalReceived(p2, p3)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceOnCrossExperienceStartedSignalReceived, {
		hasExperienceStarted = p2,
		isActiveDM = p3
	})
end

function class:logPartyVoiceStateChangeHandlerRun(p2, p3)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChangeHandlerRun, {
		isActiveDM = p2,
		status = p3.status,
		detail = p3.detail or ""
	})
end

function class:reset()
	self.previousStatus = nil
end

class.default = class.new()
return class
