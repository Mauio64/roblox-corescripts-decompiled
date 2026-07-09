local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local Players = game:GetService("Players")
local Analytics = require(CrossExperienceVoice.Analytics)
local Flags = require(CrossExperienceVoice.Flags)
local LoggingProtocol = dependencies.LoggingProtocol
local CrossExperience = dependencies.CrossExperience
local getMemStorageKey = CrossExperience.Utils.getMemStorageKey
local t1 = {}

t1.__index = t1

local CEV_JOIN_ATTEMPT_ID_KEY = CrossExperience.Constants.CEV_JOIN_ATTEMPT_ID_KEY

function t1.new() -- line: 82
	-- upvalues: Analytics (copy), t1 (copy)
	local t2 = {
		previousStatus = nil,
		isInitialized = false,
		eventManager = nil,
		connections = {},
		analytics = Analytics.Analytics()
	}

	setmetatable(t2, t1)

	return t2
end
function t1.initialize(p1, p2) -- line: 94
	p1.eventManager = p2
	p1.isInitialized = true
end
function t1.fireCEVAnalyticsEvent(t3: {[any]: any}, s1: string, p3) -- line: 99
	-- upvalues: getMemStorageKey (copy), CEV_JOIN_ATTEMPT_ID_KEY (copy)
	local v17 = p3 or {}

	v17.cevJoinAttemptId = getMemStorageKey(CEV_JOIN_ATTEMPT_ID_KEY)
	v17.clientTimeStamp = os.time()
	t3.analytics.fireAnalyticsEvent(s1, v17)
end
function t1.logPartyVoiceTimeout(t4: {[any]: any}, s2: string?) -- line: 106
	-- upvalues: Analytics (copy), CrossExperience (copy), Players (copy)
	if not t4.isInitialized then
		return
	end

	t4:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChanged, {
		partyId = s2 or "",
		status = CrossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT,
		previousStatus = t4.previousStatus or "",
		userId = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId
	})
end
function t1.logPartyVoiceStatusChanged(t5: {[any]: any}, p4, s3: string?, s4: string?) -- line: 119
	-- upvalues: Flags (copy), Analytics (copy)
	if not t5.isInitialized then
		return
	end

	if t5.previousStatus ~= p4.status then
		if Flags.FFlagEnablePartyVoiceStatusChangedDetailAnalytics then
			if Flags.FFlagPartyVoiceLogActiveDM then
				t5:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChanged, {
					partyId = s3 or "",
					status = p4.status,
					detail = p4.detail or "",
					previousStatus = t5.previousStatus or "",
					voiceChannelId = p4.voiceChannelId,
					voiceSessionId = p4.voiceSessionId,
					userId = p4.userId,
					activeDm = s4 or ""
				})
			else
				t5:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChanged, {
					activeDm = "",
					partyId = s3 or "",
					status = p4.status,
					detail = p4.detail or "",
					previousStatus = t5.previousStatus or "",
					voiceChannelId = p4.voiceChannelId,
					voiceSessionId = p4.voiceSessionId,
					userId = p4.userId
				})
			end
		else
			t5:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChanged, {
				partyId = s3 or "",
				status = p4.status,
				previousStatus = t5.previousStatus or "",
				voiceChannelId = p4.voiceChannelId,
				voiceSessionId = p4.voiceSessionId,
				userId = p4.userId
			})
		end
	end

	t5.previousStatus = p4.status
end
function t1.logPartyVoiceConnectedState(t6: {[any]: any}, p5, s5: string?, s6: string?) -- line: 171
	-- upvalues: Flags (copy), Analytics (copy)
	if not t6.isInitialized then
		return
	end

	if Flags.FFlagPartyVoiceLogActiveDM then
		t6:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceConnectedParticipantsOnJoin, {
			userId = not p5.userId and 0 or p5.userId,
			partyId = s5 or "",
			status = not p5.status and "" or p5.status,
			voiceChannelId = not p5.voiceChannelId and "" or p5.voiceChannelId,
			voiceSessionId = not p5.voiceSessionId and "" or p5.voiceSessionId,
			voicePlaySessionId = not p5.voicePlaySessionId and "" or p5.voicePlaySessionId,
			participants = not p5.participants and "" or p5.participants,
			numberActive = p5.numberActive or 0,
			activeDm = s6 or ""
		})
	else
		t6:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceConnectedParticipantsOnJoin, {
			activeDm = "",
			userId = not p5.userId and 0 or p5.userId,
			partyId = s5 or "",
			status = not p5.status and "" or p5.status,
			voiceChannelId = not p5.voiceChannelId and "" or p5.voiceChannelId,
			voiceSessionId = not p5.voiceSessionId and "" or p5.voiceSessionId,
			voicePlaySessionId = not p5.voicePlaySessionId and "" or p5.voicePlaySessionId,
			participants = not p5.participants and "" or p5.participants,
			numberActive = p5.numberActive or 0
		})
	end

	t6:logLaunchFlowEndEvent()
end
function t1.logPartyVoiceJoinAttempt(p6, p7) -- line: 209
	-- upvalues: Flags (copy), Analytics (copy)
	if not p6.isInitialized then
		return
	end

	if Flags.FFlagPartyVoiceLogActiveDM then
		p6:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceJoinAttempt, {
			userId = not p7.userId and 0 or p7.userId,
			partyId = not p7.partyId and "" or p7.partyId,
			targetPlaceId = not p7.targetPlaceId and 0 or p7.targetPlaceId,
			isConnected = not not p7.isConnected and p7.isConnected,
			activeDm = not p7.activeDm and "" or p7.activeDm
		})
	else
		p6:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceJoinAttempt, {
			activeDm = "",
			userId = not p7.userId and 0 or p7.userId,
			partyId = not p7.partyId and "" or p7.partyId,
			targetPlaceId = not p7.targetPlaceId and 0 or p7.targetPlaceId,
			isConnected = not not p7.isConnected and p7.isConnected
		})
	end

	p6:logLaunchFlowBeginEvent()
end
function t1.logLaunchFlowBeginEvent(_) -- line: 234
	-- upvalues: LoggingProtocol (copy)
	LoggingProtocol.default:logEvent("party_voice_launch_flow_begin")
end
function t1.logLaunchFlowEndEvent(_) -- line: 238
	-- upvalues: LoggingProtocol (copy)
	LoggingProtocol.default:logEvent("party_voice_launch_flow_end")
end
function t1.logPartyVoiceJoinFailure(t7: {[any]: any}, s7: string, s8: string?, n1: number?) -- line: 242
	-- upvalues: Analytics (copy)
	if not t7.isInitialized then
		return
	end

	t7:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceJoinFailure, {
		partyId = s7,
		errorMessage = s8 or "",
		userId = n1 or 0
	})
end
function t1.logPartyVoiceUnmuteParticipant(t8: {[any]: any}, s9: string, n2: number) -- line: 254
	-- upvalues: Analytics (copy)
	if not t8.isInitialized then
		return
	end

	t8:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceUnmuteParticipant, {
		partyId = s9,
		userId = n2 or 0
	})
end
function t1.logPartyVoiceMuteParticipant(t9: {[any]: any}, s10: string, n3: number) -- line: 265
	-- upvalues: Analytics (copy)
	if not t9.isInitialized then
		return
	end

	t9:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceMuteParticipant, {
		partyId = s10,
		userId = n3 or 0
	})
end
function t1.logPartyVoiceBlockParticipant(t10: {[any]: any}, s11: string, n4: number) -- line: 276
	-- upvalues: Analytics (copy)
	if not t10.isInitialized then
		return
	end

	t10:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceBlockParticipant, {
		partyId = s11,
		userId = n4 or 0
	})
end
function t1.logPartyVoiceUnblockParticipant(t11: {[any]: any}, s12: string, n5: number) -- line: 287
	-- upvalues: Analytics (copy)
	if not t11.isInitialized then
		return
	end

	t11:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceUnblockParticipant, {
		partyId = s12,
		userId = n5 or 0
	})
end
function t1.logPartyVoiceOnCrossExperienceStartedSignalReceived(t12: {[any]: any}, b1: boolean, b2: boolean) -- line: 298
	-- upvalues: Analytics (copy)
	if not t12.isInitialized then
		return
	end

	t12:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceOnCrossExperienceStartedSignalReceived, {
		hasExperienceStarted = b1,
		isActiveDM = b2
	})
end
function t1.logPartyVoiceStateChangeHandlerRun(t13: {[any]: any}, b3: boolean, p10) -- line: 311
	-- upvalues: Analytics (copy)
	if not t13.isInitialized then
		return
	end

	t13:fireCEVAnalyticsEvent(Analytics.EventNames.PartyVoiceStateChangeHandlerRun, {
		isActiveDM = b3,
		status = p10.status,
		detail = p10.detail or ""
	})
end
function t1.reset(p11) -- line: 325
	p11.previousStatus = nil
end

t1.default = t1.new()

return t1
