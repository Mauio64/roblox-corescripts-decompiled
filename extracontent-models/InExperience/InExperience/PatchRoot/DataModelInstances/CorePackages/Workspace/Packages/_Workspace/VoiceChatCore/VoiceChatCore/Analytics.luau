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

local Analytics = {}
Analytics.__index = Analytics

Analytics.INFO = "info"
Analytics.WARNING = "warning"
Analytics.ERROR = "error"

local v = {
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

local v2 = {
	Connected = {
		eventName = "VoiceConnected",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 11, 3 },
		description = "Counted wherever the voiceConnectEvent event stream event is sent, so the two stay comparable. customFields: source (the VOICE_CONNECTION_SOURCE that started the join: AUTO_CONNECT, IN_EXPERIENCE, SETTINGS_TOGGLE_ON, or none). User-initiated connects are every source except AUTO_CONNECT.",
		links = ""
	},
	Disconnected = {
		eventName = "VoiceDisconnected",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 11, 3 },
		description = "The voice session reached the Ended state, counted alongside the voiceDisconnectReasonEvent event stream event. customFields: reason (the VOICE_DISCONNECT_REASON: USER_DISCONNECT when the user turned voice off, MODERATED, or SYSTEM for everything else).",
		links = ""
	}
}

function Analytics.new(impl)
	impl = impl or RbxAnalyticsService
	assert(impl, "Analytics impl must not be nil.")

	return (setmetatable({ _impl = impl }, Analytics))
end

local function stub() end

function Analytics.stubService()
	return {
		SetRBXEvent = stub,
		SetRBXEventStream = stub,
		SendEventDeferred = stub,
		ReportCounter = stub,
		ReportStats = stub,
		ReportInfluxSeries = stub
	}
end

function Analytics:setImpl(impl)
	self._impl = impl
end

function Analytics:_report(p, p2, p3, p4)
	local v3 = p .. "-" .. p2

	if game:GetFastFlag("LuaVoiceChatAnalyticsUsePointsV2") then
		self._impl:ReportInfluxSeries(v3, p4, game:GetFastInt("LuaVoiceChatAnalyticsPointsThrottle"))
	end

	if game:GetFastFlag("LuaVoiceChatAnalyticsUseCounterV2") then
		if p3 then
			v3 ..= "-" .. p3
		end

		if p4 and p4.result then
			v3 ..= "-" .. p4.result
		end

		self._impl:ReportCounter(v3, 1)
	end

	if game:GetFastFlag("LuaVoiceChatAnalyticsUseEventsV2") then
		self._impl:SendEventDeferred("client", p, p2, p4)
	end
end

function Analytics:reportVoiceChatJoinResult(success, p, p2)
	self:_report("voiceChat", "defaultChannelJoinResults", p, {
		success = success,
		result = p,
		logLevel = p2 or Analytics.INFO
	})
end

function Analytics:reportBanMessageEvent(p: string)
	if game:GetFastFlag("LuaVoiceChatAnalyticsBanMessage") then
		self._impl:ReportCounter("voiceChat-reportBanMessage" .. p, 1)
	end
end

function Analytics:reportBanMessageEventV2(eventType: string, banReason: number, userId: number, voiceSessionId: string)
	self:_report("voiceChat", "reportBanEvent", nil, {
		eventType = eventType,
		banReason = banReason,
		userId = userId,
		voiceSessionId = voiceSessionId
	})
end

function Analytics:reportReconnectDueToMissedSequence()
	if game:GetFastFlag("LuaVoiceChatReconnectMissedSequence") then
		self._impl:ReportCounter("voiceChat-reconnectMissedSequence", 1)
	end
end

function Analytics:reportOutOfOrderSequence()
	self._impl:ReportCounter("voiceChat-outOfOrderSequence", 1)
end

function Analytics:reportReceivedNudge(p, userId: number, voiceSessionId: string)
	local unixTimestampMillis = DateTime.fromIsoDate(p.deliveryTime).UnixTimestampMillis
	local durationInMs = DateTime.now().UnixTimestampMillis - unixTimestampMillis
	self._impl:ReportCounter("voicechat-receivednudge", 1)
	self._impl:ReportCounter("voicechat-receivednudgeduration", durationInMs)
	self._impl:SendEventDeferred("client", "voiceChat", "receivedNudge", {
		type = p.type,
		durationInMs = durationInMs,
		userId = userId,
		voiceSessionId = voiceSessionId
	})
end

function Analytics:reportClosedNudge(userId: number, voiceSessionId: string)
	self._impl:ReportCounter("voicechat-closednudge", 1)
	self._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		userId = userId,
		voiceSessionId = voiceSessionId,
		closeType = "CLOSED"
	})
end

function Analytics:reportAcknowledgedNudge(userId: number, voiceSessionId: string)
	self._impl:ReportCounter("voicechat-acknowledgednudge", 1)
	self._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		userId = userId,
		voiceSessionId = voiceSessionId,
		closeType = "ACKNOWLEDGED"
	})
end

function Analytics:reportDeniedNudge(userId: number, voiceSessionId: string)
	self._impl:ReportCounter("voicechat-deniednudge", 1)
	self._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		userId = userId,
		voiceSessionId = voiceSessionId,
		closeType = "DENIED"
	})
end

function Analytics:reportVoiceMuteIndividual(data)
	self._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteIndividual", {
		user_id = data.userId,
		client_session_id = data.clientSessionId,
		target_user_id = data.targetUserId,
		channel_id = data.channelId,
		context = data.context,
		muted = data.muted
	})
end

function Analytics:reportVoiceMuteGroup(data)
	self._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteGroup", {
		user_id = data.userId,
		client_session_id = data.clientSessionId,
		channel_id = data.channelId,
		context = data.context,
		group_type = data.groupType,
		muted = data.muted
	})
end

function Analytics:reportVoiceMuteSelf(data)
	self._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteSelf", {
		user_id = data.userId,
		client_session_id = data.clientSessionId,
		channel_id = data.channelId,
		context = data.context,
		muted = data.muted
	})
end

function Analytics:reportJoinVoiceButtonEvent(eventType: string, universeId: number, placeId: number, playSessionId: string, buttonContext: string?, buttonConsequence: string?)
	self._impl:SendEventDeferred("client", "voice", "joinVoiceButtonEvent", {
		eventType = eventType,
		universeId = universeId,
		placeId = placeId,
		playSessionId = playSessionId,
		buttonContext = buttonContext,
		buttonConsequence = buttonConsequence
	})
end

function Analytics:reportJoinVoiceButtonEventWithVoiceSessionId(eventType: string, universeId: number, placeId: number, playSessionId: string, voiceSessionId: string, buttonContext: string?, buttonConsequence: string?)
	self._impl:SendEventDeferred("client", "voice", "joinVoiceButtonEvent", {
		eventType = eventType,
		universeId = universeId,
		placeId = placeId,
		playSessionId = playSessionId,
		voiceSessionId = voiceSessionId,
		buttonContext = buttonContext,
		buttonConsequence = buttonConsequence
	})
end

function Analytics.reportJoinVoiceUpsellEvent(_, p: string, playSessionId: string, user_is_age_verified: boolean, button_context: string?, button_consequence: string?)
	TelemetryService:LogEvent({
		eventName = "joinVoiceUpsell" .. p,
		backends = { "EventIngest" },
		throttlingPercentage = game:GetFastInt("LuaVoiceChatThrottleHundrethsPercent"),
		lastUpdated = { 2025, 10, 30 },
		description = "Event fired when user sees or interacts with Join Voice button",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8530"
	}, {
		customFields = {
			user_is_age_verified = user_is_age_verified,
			button_context = button_context,
			button_consequence = button_consequence,
			clientTimeStamp = DateTime.now().UnixTimestampMillis,
			playSessionId = playSessionId,
			sd_platform_id = SessionService:GetSessionID("level0"),
			sd_logged_in_id = SessionService:GetSessionID("level1")
		},
		standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo" }
	})
end

function Analytics:reportLeaveVoiceButtonEvent(eventType: string, universeId: number, placeId: number, playSessionId: string, voiceSessionId: string)
	self._impl:SendEventDeferred("client", "voice", "leaveVoiceButtonEvent", {
		eventType = eventType,
		universeId = universeId,
		placeId = placeId,
		playSessionId = playSessionId,
		voiceSessionId = voiceSessionId
	})
end

function Analytics:reportInExpConsent(eventType: string, entry: string, universeId: number, placeId: number, playSessionId: string)
	self._impl:SendEventDeferred("client", "voiceChat", "inExpConsentModalEvent", {
		eventType = eventType,
		entry = entry,
		universeId = universeId,
		placeId = placeId,
		playSessionId = playSessionId
	})
end

function Analytics:reportDevicePermissionsModalEvent(eventType: string, voiceSessionId: string, universeId: number, placeId: number, value: string)
	local playSessionId = string.sub(value, 2, #value - 1)

	self._impl:SendEventDeferred("client", "voiceChat", "devicePermissionsModalEvent", {
		eventType = eventType,
		universeId = universeId,
		placeId = placeId,
		playSessionId = playSessionId,
		voiceSessionId = voiceSessionId
	})
end

function Analytics:reportConnectDisconnectEvents(p, p2)
	self._impl:SendEventDeferred("client", "voiceChat", p, p2)
end

function Analytics:reportVoiceEvents(p, p2)
	self._impl:SendEventDeferred("client", "voice", p, p2)
end

function Analytics.reportVoiceVolumeEligibility(_, data)
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

function Analytics.reportVoiceVolumeImpressions(_, data)
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

function Analytics.reportVoiceRewarmShown(_, flag: boolean)
	TelemetryService:LogCounter(v.Shown, {
		customFields = { rearmed = tostring(flag) }
	}, 1)
end

function Analytics.reportVoiceRewarmClicked(_, flag: boolean, value: string?)
	TelemetryService:LogCounter(v.Clicked, {
		customFields = {
			rearmed = tostring(flag),
			consequence = value or "none"
		}
	}, 1)
end

function Analytics.reportVoiceConnected(_, value: string?)
	TelemetryService:LogCounter(v2.Connected, {
		customFields = {
			source = value or "none"
		}
	}, 1)
end

function Analytics.reportVoiceDisconnected(_, value: string?)
	TelemetryService:LogCounter(v2.Disconnected, {
		customFields = {
			reason = value or "none"
		}
	}, 1)
end

return Analytics
