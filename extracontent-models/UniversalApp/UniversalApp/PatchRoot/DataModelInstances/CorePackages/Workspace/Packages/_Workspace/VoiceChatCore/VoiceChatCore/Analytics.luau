local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local SessionService = game:GetService("SessionService")
local TelemetryService = game:GetService("TelemetryService")

game:DefineFastInt("LuaVoiceChatThrottleHundrethsPercent", 10000)
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

function t1.new(t2: {[any]: any}?) -- line: 137
	-- upvalues: RbxAnalyticsService (copy), t1 (copy)
	if not t2 then
		t2 = RbxAnalyticsService
	end

	assert(t2, "Analytics impl must not be nil.")

	return (setmetatable({
		_impl = t2
	}, t1))
end

local function stub() -- line: 150
end

function t1.stubService() -- line: 152
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
function t1.setImpl(p1, p2) -- line: 163
	p1._impl = p2
end
function t1._report(p3, p4, p5, p6, p7) -- line: 167
	local v14 = p4 .. "-" .. p5

	if game:GetFastFlag("LuaVoiceChatAnalyticsUsePointsV2") then
		p3._impl:ReportInfluxSeries(v14, p7, game:GetFastInt("LuaVoiceChatAnalyticsPointsThrottle"))
	end

	if game:GetFastFlag("LuaVoiceChatAnalyticsUseCounterV2") then
		if p6 then
			v14 ..= "-" .. p6
		end

		if p7 and p7.result then
			v14 ..= "-" .. p7.result
		end

		p3._impl:ReportCounter(v14, 1)
	end

	if game:GetFastFlag("LuaVoiceChatAnalyticsUseEventsV2") then
		p3._impl:SendEventDeferred("client", p4, p5, p7)
	end
end
function t1.reportVoiceChatJoinResult(p8, p9, p10, p11) -- line: 189
	-- upvalues: t1 (copy)
	p8:_report("voiceChat", "defaultChannelJoinResults", p10, {
		success = p9,
		result = p10,
		logLevel = p11 or t1.INFO
	})
end
function t1.reportBanMessageEvent(t3: {[any]: any}, s1: string) -- line: 197
	if game:GetFastFlag("LuaVoiceChatAnalyticsBanMessage") then
		t3._impl:ReportCounter("voiceChat-reportBanMessage" .. s1, 1)
	end
end
function t1.reportBanMessageEventV2(t4: {[any]: any}, s2: string, n1: number, n2: number, s3: string) -- line: 203
	t4:_report("voiceChat", "reportBanEvent", nil, {
		eventType = s2,
		banReason = n1,
		userId = n2,
		voiceSessionId = s3
	})
end
function t1.reportReconnectDueToMissedSequence(p12) -- line: 212
	if game:GetFastFlag("LuaVoiceChatReconnectMissedSequence") then
		p12._impl:ReportCounter("voiceChat-reconnectMissedSequence", 1)
	end
end
function t1.reportOutOfOrderSequence(p13) -- line: 218
	p13._impl:ReportCounter("voiceChat-outOfOrderSequence", 1)
end
function t1.reportReceivedNudge(t5: {[any]: any}, t6: {[any]: any}, n3: number, s4: string) -- line: 222
	local UnixTimestampMillis = DateTime.fromIsoDate(t6.deliveryTime).UnixTimestampMillis
	local v33 = DateTime.now().UnixTimestampMillis - UnixTimestampMillis

	t5._impl:ReportCounter("voicechat-receivednudge", 1)
	t5._impl:ReportCounter("voicechat-receivednudgeduration", v33)
	t5._impl:SendEventDeferred("client", "voiceChat", "receivedNudge", {
		type = t6.type,
		durationInMs = v33,
		userId = n3,
		voiceSessionId = s4
	})
end
function t1.reportClosedNudge(t7: {[any]: any}, n4: number, s5: string) -- line: 239
	t7._impl:ReportCounter("voicechat-closednudge", 1)
	t7._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		closeType = "CLOSED",
		userId = n4,
		voiceSessionId = s5
	})
end
function t1.reportAcknowledgedNudge(t8: {[any]: any}, n5: number, s6: string) -- line: 248
	t8._impl:ReportCounter("voicechat-acknowledgednudge", 1)
	t8._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		closeType = "ACKNOWLEDGED",
		userId = n5,
		voiceSessionId = s6
	})
end
function t1.reportDeniedNudge(t9: {[any]: any}, n6: number, s7: string) -- line: 257
	t9._impl:ReportCounter("voicechat-deniednudge", 1)
	t9._impl:SendEventDeferred("client", "voiceChat", "closedNudge", {
		closeType = "DENIED",
		userId = n6,
		voiceSessionId = s7
	})
end
function t1.reportVoiceMuteIndividual(t10: {[any]: any}, t11: {[any]: any}) -- line: 266
	t10._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteIndividual", {
		user_id = t11.userId,
		client_session_id = t11.clientSessionId,
		target_user_id = t11.targetUserId,
		channel_id = t11.channelId,
		context = t11.context,
		muted = t11.muted
	})
end
function t1.reportVoiceMuteGroup(t12: {[any]: any}, t13: {[any]: any}) -- line: 277
	t12._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteGroup", {
		user_id = t13.userId,
		client_session_id = t13.clientSessionId,
		channel_id = t13.channelId,
		context = t13.context,
		group_type = t13.groupType,
		muted = t13.muted
	})
end
function t1.reportVoiceMuteSelf(t14: {[any]: any}, t15: {[any]: any}) -- line: 288
	t14._impl:SendEventDeferred("client", "voice", "voiceUIMuteUnmuteSelf", {
		user_id = t15.userId,
		client_session_id = t15.clientSessionId,
		channel_id = t15.channelId,
		context = t15.context,
		muted = t15.muted
	})
end
function t1.reportJoinVoiceButtonEvent(t16: {[any]: any}, s8: string, n7: number, n8: number, s9: string, s10: string?, s11: string?) -- line: 298
	t16._impl:SendEventDeferred("client", "voice", "joinVoiceButtonEvent", {
		eventType = s8,
		universeId = n7,
		placeId = n8,
		playSessionId = s9,
		buttonContext = s10,
		buttonConsequence = s11
	})
end
function t1.reportJoinVoiceButtonEventWithVoiceSessionId(t17: {[any]: any}, s12: string, n9: number, n10: number, s13: string, s14: string, s15: string?, s16: string?) -- line: 316
	t17._impl:SendEventDeferred("client", "voice", "joinVoiceButtonEvent", {
		eventType = s12,
		universeId = n9,
		placeId = n10,
		playSessionId = s13,
		voiceSessionId = s14,
		buttonContext = s15,
		buttonConsequence = s16
	})
end
function t1.reportJoinVoiceUpsellEvent(_: {[any]: any}, s17: string, s18: string, b1: boolean, s19: string?, s20: string?) -- line: 336
	-- upvalues: SessionService (copy), TelemetryService (copy)
	local t19 = {
		description = "Event fired when user sees or interacts with Join Voice button",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8530",
		eventName = "joinVoiceUpsell" .. s17,
		backends = { "EventIngest" },
		throttlingPercentage = game:GetFastInt("LuaVoiceChatThrottleHundrethsPercent"),
		lastUpdated = {
			2025,
			10,
			30
		}
	}
	local t20 = {
		user_is_age_verified = b1,
		button_context = s19,
		button_consequence = s20,
		clientTimeStamp = DateTime.now().UnixTimestampMillis,
		playSessionId = s18,
		sd_platform_id = SessionService:GetSessionID("level0"),
		sd_logged_in_id = SessionService:GetSessionID("level1")
	}

	TelemetryService:LogEvent(t19, {
		customFields = t20,
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addSessionInfo"
		}
	})
end
function t1.reportLeaveVoiceButtonEvent(t21: {[any]: any}, s21: string, n11: number, n12: number, s22: string, s23: string) -- line: 369
	t21._impl:SendEventDeferred("client", "voice", "leaveVoiceButtonEvent", {
		eventType = s21,
		universeId = n11,
		placeId = n12,
		playSessionId = s22,
		voiceSessionId = s23
	})
end
function t1.reportInExpConsent(t22: {[any]: any}, s24: string, s25: string, n13: number, n14: number, s26: string) -- line: 385
	t22._impl:SendEventDeferred("client", "voiceChat", "inExpConsentModalEvent", {
		eventType = s24,
		entry = s25,
		universeId = n13,
		placeId = n14,
		playSessionId = s26
	})
end
function t1.reportDevicePermissionsModalEvent(t23: {[any]: any}, s27: string, s28: string, n15: number, n16: number, s29: string) -- line: 401
	local v90 = string.sub(s29, 2, #s29 - 1)

	t23._impl:SendEventDeferred("client", "voiceChat", "devicePermissionsModalEvent", {
		eventType = s27,
		universeId = n15,
		placeId = n16,
		playSessionId = v90,
		voiceSessionId = s28
	})
end
function t1.reportConnectDisconnectEvents(p14, p15, p16) -- line: 420
	p14._impl:SendEventDeferred("client", "voiceChat", p15, p16)
end
function t1.reportVoiceEvents(p17, p18, p19) -- line: 424
	p17._impl:SendEventDeferred("client", "voice", p18, p19)
end

return t1
