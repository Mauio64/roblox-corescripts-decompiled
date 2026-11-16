local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local Players = game:GetService("Players")

local Analytics = require(CrossExperienceVoice.Analytics)
local Flags = require(CrossExperienceVoice.Flags)
local loggingProtocol = dependencies.LoggingProtocol

local crossExperience = dependencies.CrossExperience
local getMemStorageKey = crossExperience.Utils.getMemStorageKey

local CrossExperienceVoiceAnalytics = {}
CrossExperienceVoiceAnalytics.__index = CrossExperienceVoiceAnalytics

local CEV_JOIN_ATTEMPT_ID_KEY = crossExperience.Constants.CEV_JOIN_ATTEMPT_ID_KEY

function CrossExperienceVoiceAnalytics.new()
	local v = {
		previousStatus = nil,
		connections = {},
		isInitialized = false,
		eventManager = nil,
		analytics = Analytics.Analytics()
	}

	setmetatable(v, CrossExperienceVoiceAnalytics)
	return v
end

function CrossExperienceVoiceAnalytics:initialize(eventManager)
	self.eventManager = eventManager
	self.isInitialized = true
end

function CrossExperienceVoiceAnalytics:fireCEVAnalyticsEvent(p: string, options)
	local v = options or {}
	v.cevJoinAttemptId = getMemStorageKey(CEV_JOIN_ATTEMPT_ID_KEY)
	v.clientTimeStamp = os.time()
	self.analytics.fireAnalyticsEvent(p, v)
end

function CrossExperienceVoiceAnalytics:logPartyVoiceTimeout(value: string?)
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

function CrossExperienceVoiceAnalytics:logPartyVoiceStatusChanged(data, value: string?, value2: string?)
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

function CrossExperienceVoiceAnalytics:logPartyVoiceConnectedState(data, value: string?, value2: string?)
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

function CrossExperienceVoiceAnalytics:logPartyVoiceJoinAttempt(data)
	if not self.isInitialized then
		return
	end

	if Flags.FFlagPartyVoiceLogActiveDM then
		local partyVoiceJoinAttempt = Analytics.EventNames.PartyVoiceJoinAttempt
		local v = {
			userId = not data.userId and 0 or data.userId,
			partyId = not data.partyId and "" or data.partyId,
			targetPlaceId = not data.targetPlaceId and 0 or data.targetPlaceId,
			isConnected = 0,
			activeDm = 0
		}
		local isConnected

		if data.isConnected then
			isConnected = data.isConnected
		else
			isConnected = false
		end

		v.isConnected = isConnected
		v.activeDm = not data.activeDm and "" or data.activeDm
		self:fireCEVAnalyticsEvent(partyVoiceJoinAttempt, v)
	else
		local partyVoiceJoinAttempt = Analytics.EventNames.PartyVoiceJoinAttempt
		local v = {
			userId = not data.userId and 0 or data.userId,
			partyId = not data.partyId and "" or data.partyId,
			targetPlaceId = not data.targetPlaceId and 0 or data.targetPlaceId,
			isConnected = 0,
			activeDm = ""
		}
		local isConnected

		if data.isConnected then
			isConnected = data.isConnected
		else
			isConnected = false
		end

		v.isConnected = isConnected
		self:fireCEVAnalyticsEvent(partyVoiceJoinAttempt, v)
	end

	self:logLaunchFlowBeginEvent()
end

function CrossExperienceVoiceAnalytics:logLaunchFlowBeginEvent()
	loggingProtocol.default:logEvent("party_voice_launch_flow_begin")
end

function CrossExperienceVoiceAnalytics:logLaunchFlowEndEvent()
	loggingProtocol.default:logEvent("party_voice_launch_flow_end")
end

function CrossExperienceVoiceAnalytics:logPartyVoiceJoinFailure(partyId: string, value: string?, value2: number?)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceJoinFailure, {
		partyId = partyId,
		errorMessage = value or "",
		userId = value2 or 0
	})
end

function CrossExperienceVoiceAnalytics:logPartyVoiceUnmuteParticipant(partyId: string, value: number)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceUnmuteParticipant, {
		partyId = partyId,
		userId = value or 0
	})
end

function CrossExperienceVoiceAnalytics:logPartyVoiceMuteParticipant(partyId: string, value: number)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceMuteParticipant, {
		partyId = partyId,
		userId = value or 0
	})
end

function CrossExperienceVoiceAnalytics:logPartyVoiceBlockParticipant(partyId: string, value: number)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceBlockParticipant, {
		partyId = partyId,
		userId = value or 0
	})
end

function CrossExperienceVoiceAnalytics:logPartyVoiceUnblockParticipant(partyId: string, value: number)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceUnblockParticipant, {
		partyId = partyId,
		userId = value or 0
	})
end

function CrossExperienceVoiceAnalytics:logPartyVoiceOnCrossExperienceStartedSignalReceived(hasExperienceStarted: boolean, isActiveDM: boolean)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceOnCrossExperienceStartedSignalReceived, {
		hasExperienceStarted = hasExperienceStarted,
		isActiveDM = isActiveDM
	})
end

function CrossExperienceVoiceAnalytics:logPartyVoiceStateChangeHandlerRun(isActiveDM: boolean, p)
	if not self.isInitialized then
		return
	end

	self:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChangeHandlerRun, {
		isActiveDM = isActiveDM,
		status = p.status,
		detail = p.detail or ""
	})
end

function CrossExperienceVoiceAnalytics:reset()
	self.previousStatus = nil
end

CrossExperienceVoiceAnalytics.default = CrossExperienceVoiceAnalytics.new()
return CrossExperienceVoiceAnalytics
