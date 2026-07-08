local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

game:DefineFastInt("LuaVoiceChatAnalyticsPointsThrottle", 0)
game:DefineFastFlag("LuaVoiceChatAnalyticsUsePointsV2", false)
game:DefineFastFlag("LuaVoiceChatAnalyticsUseCounterV2", false)
game:DefineFastFlag("LuaVoiceChatAnalyticsUseEventsV2", false)
game:DefineFastFlag("LuaVoiceChatAnalyticsBanMessage", true)
game:DefineFastFlag("LuaVoiceChatReconnectMissedSequence", false)

local t1 = {}

t1.__index = t1
t1.INFO = "info"
t1.WARNING = "warning"
t1.ERROR = "error"

function t1.new(t2: {[any]: any}?) -- line: 114
	-- upvalues: RbxAnalyticsService (copy), t1 (copy)
	if not t2 then
		t2 = RbxAnalyticsService
	end

	assert(t2, "Analytics impl must not be nil.")

	return (setmetatable({
		_impl = t2
	}, t1))
end

local function stub() -- line: 127
end

function t1.stubService() -- line: 129
	-- upvalues: stub (copy)
	return {
		SetRBXEvent = stub,
		SetRBXEventStream = stub,
		SendEventDeferred = stub,
		ReportCounter = stub,
		ReportStats = stub,
		ReportInfluxSeries = stub
	}
end
function t1.setImpl(p1, p2) -- line: 140
	p1._impl = p2
end
function t1._report(p3, p4, p5, p6, p7) -- line: 144
	local v12 = p4 .. "-" .. p5

	if game:GetFastFlag("LuaVoiceChatAnalyticsUsePointsV2") then
		p3._impl:ReportInfluxSeries(v12, p7, game:GetFastInt("LuaVoiceChatAnalyticsPointsThrottle"))
	end

	if game:GetFastFlag("LuaVoiceChatAnalyticsUseCounterV2") then
		if p6 then
			v12 ..= "-" .. p6
		end

		if p7 and p7.result then
			v12 ..= "-" .. p7.result
		end

		p3._impl:ReportCounter(v12, 1)
	end

	if game:GetFastFlag("LuaVoiceChatAnalyticsUseEventsV2") then
		p3._impl:SendEventDeferred("client", p4, p5, p7)
	end
end
function t1.reportVoiceChatJoinResult(p8, p9, p10, p11) -- line: 166
	-- upvalues: t1 (copy)
	p8:_report("voiceChat", "defaultChannelJoinResults", p10, {
		success = p9,
		result = p10,
		logLevel = p11 or t1.INFO
	})
end
function t1.reportBanMessageEvent(t3: {[any]: any}, s1: string) -- line: 174
	if game:GetFastFlag("LuaVoiceChatAnalyticsBanMessage") then
		t3._impl:ReportCounter("voiceChat-reportBanMessage" .. s1, 1)
	end
end
function t1.reportBanMessageEventV2(t4: {[any]: any}, s2: string, n1: number, n2: number, s3: string) -- line: 180
	t4:_report("voiceChat", "reportBanEvent", nil, {
		eventType = s2,
		banReason = n1,
		userId = n2,
		voiceSessionId = s3
	})
end
function t1.reportReconnectDueToMissedSequence(p12) -- line: 189
	if game:GetFastFlag("LuaVoiceChatReconnectMissedSequence") then
		p12._impl:ReportCounter("voiceChat-reconnectMissedSequence", 1)
	end
end
function t1.reportOutOfOrderSequence(p13) -- line: 195
	p13._impl:ReportCounter("voiceChat-outOfOrderSequence", 1)
end
function t1.reportClosedNudge(t5: {[any]: any}, n3: number, s4: string) -- line: 199
	t5._impl:ReportCounter("voicechat-closednudge", 1)
	t5._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		closeType = "CLOSED",
		userId = n3,
		voiceSessionId = s4
	})
end
function t1.reportAcknowledgedNudge(t6: {[any]: any}, n4: number, s5: string) -- line: 208
	t6._impl:ReportCounter("voicechat-acknowledgednudge", 1)
	t6._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		closeType = "ACKNOWLEDGED",
		userId = n4,
		voiceSessionId = s5
	})
end
function t1.reportDeniedNudge(t7: {[any]: any}, n5: number, s6: string) -- line: 217
	t7._impl:ReportCounter("voicechat-deniednudge", 1)
	t7._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		closeType = "DENIED",
		userId = n5,
		voiceSessionId = s6
	})
end
function t1.reportVoiceMuteIndividual(t8: {[any]: any}, t9: {[any]: any}) -- line: 226
	t8._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteIndividual", {
		user_id = t9.userId,
		client_session_id = t9.clientSessionId,
		target_user_id = t9.targetUserId,
		channel_id = t9.channelId,
		context = t9.context,
		muted = t9.muted
	})
end
function t1.reportVoiceMuteGroup(t10: {[any]: any}, t11: {[any]: any}) -- line: 237
	t10._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteGroup", {
		user_id = t11.userId,
		client_session_id = t11.clientSessionId,
		channel_id = t11.channelId,
		context = t11.context,
		group_type = t11.groupType,
		muted = t11.muted
	})
end
function t1.reportVoiceMuteSelf(t12: {[any]: any}, t13: {[any]: any}) -- line: 248
	t12._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteSelf", {
		user_id = t13.userId,
		client_session_id = t13.clientSessionId,
		channel_id = t13.channelId,
		context = t13.context,
		muted = t13.muted
	})
end
function t1.reportJoinVoiceButtonEvent(t14: {[any]: any}, s7: string, n6: number, n7: number, s8: string, s9: string?, s10: string?) -- line: 258
	t14._impl:SendEventDeferred("client", "voice", "joinVoiceButtonEvent", {
		eventType = s7,
		universeId = n6,
		placeId = n7,
		playSessionId = s8,
		buttonContext = s9,
		buttonConsequence = s10
	})
end
function t1.reportJoinVoiceButtonEventWithVoiceSessionId(t15: {[any]: any}, s11: string, n8: number, n9: number, s12: string, s13: string, s14: string?, s15: string?) -- line: 276
	t15._impl:SendEventDeferred("client", "voice", "joinVoiceButtonEvent", {
		eventType = s11,
		universeId = n8,
		placeId = n9,
		playSessionId = s12,
		voiceSessionId = s13,
		buttonContext = s14,
		buttonConsequence = s15
	})
end
function t1.reportLeaveVoiceButtonEvent(t16: {[any]: any}, s16: string, n10: number, n11: number, s17: string, s18: string) -- line: 296
	t16._impl:SendEventDeferred("client", "voice", "leaveVoiceButtonEvent", {
		eventType = s16,
		universeId = n10,
		placeId = n11,
		playSessionId = s17,
		voiceSessionId = s18
	})
end
function t1.reportInExpConsent(t17: {[any]: any}, s19: string, s20: string, n12: number, n13: number, s21: string) -- line: 312
	t17._impl:SendEventDeferred("client", "voiceChat", "inExpConsentModalEvent", {
		eventType = s19,
		entry = s20,
		universeId = n12,
		placeId = n13,
		playSessionId = s21
	})
end
function t1.reportDevicePermissionsModalEvent(t18: {[any]: any}, s22: string, s23: string, n14: number, n15: number, s24: string) -- line: 328
	local v74 = string.sub(s24, 2, #s24 - 1)

	t18._impl:SendEventDeferred("client", "voiceChat", "devicePermissionsModalEvent", {
		eventType = s22,
		universeId = n14,
		placeId = n15,
		playSessionId = v74,
		voiceSessionId = s23
	})
end
function t1.reportConnectDisconnectEvents(p14, p15, p16) -- line: 347
	p14._impl:SendEventDeferred("client", "voiceChat", p15, p16)
end

return t1
