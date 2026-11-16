local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local SessionService = game:GetService("SessionService")
local TelemetryService = game:GetService("TelemetryService")
game:DefineFastInt("LuaVoiceChatThrottleHundrethsPercent", 10000)
game:DefineFastInt("LuaVoiceVolumeControlsEligibilityThrottleHundredthsPercent", 10000)
game:DefineFastInt("LuaVoiceVolumeControlsImpressionsThrottleHundredthsPercent", 10000)

game:DefineFastInt("LuaVoiceChatAnalyticsPointsThrottle", 0)
game:DefineFastFlag("LuaVoiceChatAnalyticsUsePointsV2", false)
game:DefineFastFlag("LuaVoiceChatAnalyticsUseCounterV2", false)
game:DefineFastFlag("LuaVoiceChatAnalyticsUseEventsV2", false)
game:DefineFastFlag("LuaVoiceChatAnalyticsBanMessage", true)
game:DefineFastFlag("LuaVoiceChatReconnectMissedSequence", false)

local class = {}
class.__index = class

class.INFO = "info"
class.WARNING = "warning"
class.ERROR = "error"

local v5 = {
	Shown = {
		eventName = "VoiceRewarmShown",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 10, 22 },
		description = "The voice rewarm join-voice icon became available in the Chrome top bar, at most once per session. Rewarm clicks from VR or the settings menu have no matching Shown. customFields: rearmed (true when the user had already consumed a rewarm and FIntVoiceRewarmReArmCount re-armed it).",
		links = ""
	},
	Clicked = {
		eventName = "VoiceRewarmClicked",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 10, 22 },
		description = "The user clicked the voice rewarm join-voice icon, consuming the rewarm. customFields: rearmed, consequence (what JoinVoice did, e.g. FirstJoinSession, FaeUpsell, ConsentModal, or none).",
		links = ""
	}
}

function class.new(p2)
	local v6 = p2 or RbxAnalyticsService
	assert(v6, "Analytics impl must not be nil.")

	return (setmetatable({ _impl = v6 }, class))
end

local function stub() end

function class.stubService()
	return {
		SetRBXEvent = stub,
		SetRBXEventStream = stub,
		SendEventDeferred = stub,
		ReportCounter = stub,
		ReportStats = stub,
		ReportInfluxSeries = stub
	}
end

function class:setImpl(impl)
	self._impl = impl
end

function class:_report(p3, p4, p5, p6)
	local v6 = p3 .. "-" .. p4

	if game:GetFastFlag("LuaVoiceChatAnalyticsUsePointsV2") then
		self._impl:ReportInfluxSeries(v6, p6, game:GetFastInt("LuaVoiceChatAnalyticsPointsThrottle"))
	end

	if game:GetFastFlag("LuaVoiceChatAnalyticsUseCounterV2") then
		if p5 then
			v6 ..= "-" .. p5
		end

		if p6 and p6.result then
			v6 ..= "-" .. p6.result
		end

		self._impl:ReportCounter(v6, 1)
	end

	if game:GetFastFlag("LuaVoiceChatAnalyticsUseEventsV2") then
		self._impl:SendEventDeferred("client", p3, p4, p6)
	end
end

function class:reportVoiceChatJoinResult(p2, p3, p4)
	self:_report("voiceChat", "defaultChannelJoinResults", p3, {
		success = p2,
		result = p3,
		logLevel = p4 or class.INFO
	})
end

function class:reportBanMessageEvent(p3)
	if game:GetFastFlag("LuaVoiceChatAnalyticsBanMessage") then
		self._impl:ReportCounter("voiceChat-reportBanMessage" .. p3, 1)
	end
end

function class:reportBanMessageEventV2(p2, p3, p4, p5)
	self:_report("voiceChat", "reportBanEvent", nil, {
		eventType = p2,
		banReason = p3,
		userId = p4,
		voiceSessionId = p5
	})
end

function class:reportReconnectDueToMissedSequence()
	if game:GetFastFlag("LuaVoiceChatReconnectMissedSequence") then
		self._impl:ReportCounter("voiceChat-reconnectMissedSequence", 1)
	end
end

function class:reportOutOfOrderSequence()
	self._impl:ReportCounter("voiceChat-outOfOrderSequence", 1)
end

function class:reportReceivedNudge(p3, p4, p5)
	local unixTimestampMillis = DateTime.fromIsoDate(p3.deliveryTime).UnixTimestampMillis
	local v6 = DateTime.now().UnixTimestampMillis - unixTimestampMillis
	self._impl:ReportCounter("voicechat-receivednudge", 1)
	self._impl:ReportCounter("voicechat-receivednudgeduration", v6)
	self._impl:SendEventDeferred("client", "voiceChat", "receivedNudge", {
		type = p3.type,
		durationInMs = v6,
		userId = p4,
		voiceSessionId = p5
	})
end

function class:reportClosedNudge(p3, p4)
	self._impl:ReportCounter("voicechat-closednudge", 1)
	self._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		userId = p3,
		voiceSessionId = p4,
		closeType = "CLOSED"
	})
end

function class:reportAcknowledgedNudge(p3, p4)
	self._impl:ReportCounter("voicechat-acknowledgednudge", 1)
	self._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		userId = p3,
		voiceSessionId = p4,
		closeType = "ACKNOWLEDGED"
	})
end

function class:reportDeniedNudge(p3, p4)
	self._impl:ReportCounter("voicechat-deniednudge", 1)
	self._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		userId = p3,
		voiceSessionId = p4,
		closeType = "DENIED"
	})
end

function class:reportVoiceMuteIndividual(data)
	self._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteIndividual", {
		user_id = data.userId,
		client_session_id = data.clientSessionId,
		target_user_id = data.targetUserId,
		channel_id = data.channelId,
		context = data.context,
		muted = data.muted
	})
end

function class:reportVoiceMuteGroup(data)
	self._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteGroup", {
		user_id = data.userId,
		client_session_id = data.clientSessionId,
		channel_id = data.channelId,
		context = data.context,
		group_type = data.groupType,
		muted = data.muted
	})
end

function class:reportVoiceMuteSelf(data)
	self._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteSelf", {
		user_id = data.userId,
		client_session_id = data.clientSessionId,
		channel_id = data.channelId,
		context = data.context,
		muted = data.muted
	})
end

function class:reportJoinVoiceButtonEvent(p3, p4, p5, p6, p7, p8)
	self._impl:SendEventDeferred("client", "voice", "joinVoiceButtonEvent", {
		eventType = p3,
		universeId = p4,
		placeId = p5,
		playSessionId = p6,
		buttonContext = p7,
		buttonConsequence = p8
	})
end

function class:reportJoinVoiceButtonEventWithVoiceSessionId(p3, p4, p5, p6, p7, p8, p9)
	self._impl:SendEventDeferred("client", "voice", "joinVoiceButtonEvent", {
		eventType = p3,
		universeId = p4,
		placeId = p5,
		playSessionId = p6,
		voiceSessionId = p7,
		buttonContext = p8,
		buttonConsequence = p9
	})
end

function class.reportJoinVoiceUpsellEvent(p2, p3, p4, p5, p6, p7)
	TelemetryService:LogEvent({
		eventName = "joinVoiceUpsell" .. p3,
		backends = { "EventIngest" },
		throttlingPercentage = game:GetFastInt("LuaVoiceChatThrottleHundrethsPercent"),
		lastUpdated = { 2025, 10, 30 },
		description = "Event fired when user sees or interacts with Join Voice button",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8530"
	}, {
		customFields = {
			user_is_age_verified = p5,
			button_context = p6,
			button_consequence = p7,
			clientTimeStamp = DateTime.now().UnixTimestampMillis,
			playSessionId = p4,
			sd_platform_id = SessionService:GetSessionID("level0"),
			sd_logged_in_id = SessionService:GetSessionID("level1")
		},
		standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo" }
	})
end

function class:reportLeaveVoiceButtonEvent(p3, p4, p5, p6, p7)
	self._impl:SendEventDeferred("client", "voice", "leaveVoiceButtonEvent", {
		eventType = p3,
		universeId = p4,
		placeId = p5,
		playSessionId = p6,
		voiceSessionId = p7
	})
end

function class:reportInExpConsent(p3, p4, p5, p6, p7)
	self._impl:SendEventDeferred("client", "voiceChat", "inExpConsentModalEvent", {
		eventType = p3,
		entry = p4,
		universeId = p5,
		placeId = p6,
		playSessionId = p7
	})
end

function class:reportDevicePermissionsModalEvent(p3, p4, p5, p6, value)
	local v6 = string.sub(value, 2, #value - 1)

	self._impl:SendEventDeferred("client", "voiceChat", "devicePermissionsModalEvent", {
		eventType = p3,
		universeId = p5,
		placeId = p6,
		playSessionId = v6,
		voiceSessionId = p4
	})
end

function class:reportConnectDisconnectEvents(p3, p4)
	self._impl:SendEventDeferred("client", "voiceChat", p3, p4)
end

function class:reportVoiceEvents(p3, p4)
	self._impl:SendEventDeferred("client", "voice", p3, p4)
end

function class:reportVoiceVolumeEligibility(data)
	TelemetryService:LogEvent({
		eventName = "VoiceVolumeControlsEligibility",
		backends = { "EventIngest" },
		throttlingPercentage = game:GetFastInt("LuaVoiceVolumeControlsEligibilityThrottleHundredthsPercent"),
		lastUpdated = { 2026, 7, 7 },
		description = "Records voice volume eligibility state on voice join for VVC telemetry",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/voice/voice_volume_controls_eligibility.proto"
	}, {
		customFields = {
			playSessionId = data.playSessionId,
			voiceSessionId = data.voiceSessionId,
			voiceChatVolume = data.voiceChatVolume,
			usesNewAudioApi = data.usesNewAudioApi,
			enablesVoiceVolumeControls = data.enablesVoiceVolumeControls,
			isEligible = data.isEligible
		},
		standardizedFields = { "addPlaceId", "addUniverseId" }
	})
end

function class:reportVoiceVolumeImpressions(data)
	TelemetryService:LogEvent({
		eventName = "VoiceVolumeControlsImpressions",
		backends = { "EventIngest" },
		throttlingPercentage = game:GetFastInt("LuaVoiceVolumeControlsImpressionsThrottleHundredthsPercent"),
		lastUpdated = { 2026, 7, 7 },
		description = "Records whether the voice volume slider was seen during a voice session for Voice Volume Controls telemetry. Only recorded for voice volume control eligible users",
		links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/voice/voice_volume_controls_impressions.proto"
	}, {
		customFields = {
			playSessionId = data.playSessionId,
			voiceSessionId = data.voiceSessionId,
			sliderSeen = data.sliderSeen,
			voiceJoinTimestampMs = data.voiceJoinTimestampMs,
			sliderSeenTimestampMs = data.sliderSeenTimestampMs
		},
		standardizedFields = { "addPlaceId", "addUniverseId" }
	})
end

function class.reportVoiceRewarmShown(p2, p3)
	TelemetryService:LogCounter(v5.Shown, {
		customFields = { rearmed = tostring(p3) }
	}, 1)
end

function class.reportVoiceRewarmClicked(p2, p3, value)
	TelemetryService:LogCounter(v5.Clicked, {
		customFields = {
			rearmed = tostring(p3),
			consequence = value or "none"
		}
	}, 1)
end

return class
