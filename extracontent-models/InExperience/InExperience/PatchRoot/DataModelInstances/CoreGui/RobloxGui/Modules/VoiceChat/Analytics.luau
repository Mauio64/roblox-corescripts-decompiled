local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

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
	local v = p .. "-" .. p2

	if game:GetFastFlag("LuaVoiceChatAnalyticsUsePointsV2") then
		self._impl:ReportInfluxSeries(v, p4, game:GetFastInt("LuaVoiceChatAnalyticsPointsThrottle"))
	end

	if game:GetFastFlag("LuaVoiceChatAnalyticsUseCounterV2") then
		if p3 then
			v ..= "-" .. p3
		end

		if p4 and p4.result then
			v ..= "-" .. p4.result
		end

		self._impl:ReportCounter(v, 1)
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

return Analytics
