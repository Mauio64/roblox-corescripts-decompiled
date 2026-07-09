local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local v3 = require(AppChat.Logger):new("AppChatPerf")
local TimeToInteractiveTracker = require(AppChatParent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Milestone = TimeToInteractiveTracker.Milestone
local Cryo = require(AppChatParent.Cryo)

require(AppChatParent.SocialCommon)

local AppChatPerfEventInfo = require(AppChat.Telemetry.AppChatPerfEventInfo)

require(AppChat.Contexts.ChatPlacementContext)

local t1 = {
	started = false,
	interactive = false,
	interactiveTimestamp = nil,
	eventName = nil
}
local t2 = {}

local function getTTIState(p1) -- line: 60
	-- upvalues: t2 (copy), t1 (copy)
	if not t2[p1] then
		t2[p1] = table.clone(t1)
	end

	return t2[p1]
end

local u11 = nil
local t3 = {}
local t4 = {
	category = AppChatPerfEventInfo.TTI_CATEGORY
}
local u14 = nil

local function alwaysMatch(_: {[any]: any}) -- line: 101
	return true, nil
end
local function matchConversation(t6: {[any]: any}) -- line: 105
	-- upvalues: u11 (ref)
	if t6.conversationId and (u11 and t6.conversationId ~= u11) then
		return false, "conversation_id_mismatch"
	end

	return true, nil
end
local function onStartConversation(t7: {[any]: any}) -- line: 112
	-- upvalues: u11 (ref), u14 (ref)
	local conversationId = t7.conversationId

	if conversationId ~= nil and conversationId ~= u11 then
		u11 = conversationId

		if u14 then
			u14("ChatConversationTTI")
		end
	end
end
local function noColdStart(_: {[any]: any}) -- line: 123
	return false
end

local t9 = {
	useBaseName = true,
	noInteractiveState = true,
	getColdStart = noColdStart,
	isContextMatching = matchConversation
}
local t12 = {
	ChatLandingTTI = {
		getColdStart = function(t10: {[any]: any}) -- line: 136
			return t10.coldStart == true
		end,
		isContextMatching = alwaysMatch
	},
	ChatConversationTTI = {
		getColdStart = function(t11: {[any]: any}) -- line: 142
			-- upvalues: t3 (copy)
			local conversationId = t11.conversationId
			local v31 = conversationId ~= nil and not t3[conversationId]

			if conversationId then
				t3[conversationId] = true
			end

			return v31
		end,
		isContextMatching = matchConversation,
		onStart = onStartConversation
	},
	MessageSendTTI = t9,
	MessageReceiveTTI = t9
}

local function buildTTIMetadata(p2, t13: {[any]: any}?) -- line: 162
	-- upvalues: AppChatPerfEventInfo (copy), Cryo (copy), t4 (ref)
	local v34 = AppChatPerfEventInfo.getTTIPage(p2)

	return Cryo.Dictionary.join(t4, {
		subcategory = v34,
		page = v34
	}, t13 or {})
end

return {
	setSharedContext = function(t14: {[any]: any}) -- line: 176
		-- upvalues: t4 (ref), Cryo (copy), v3 (copy)
		t4 = Cryo.Dictionary.join(t4, t14)
		v3:debug("Shared context updated: placement={}, entryPoint={}, hasActiveParty={}", t14.placement or "nil", t14.entryPoint or "nil", t14.hasActiveParty or false)
	end,
	getSharedContext = function() -- line: 186
		-- upvalues: t4 (ref)
		return t4
	end,
	setOnConversationSwitch = function(p3: ((...any) -> ...any)) -- line: 192
		-- upvalues: u14 (ref)
		u14 = p3
	end,
	start = function(p4, t15: {[any]: any}) -- line: 196
		-- upvalues: t2 (copy), v3 (copy), t12 (copy), AppChatPerfEventInfo (copy), t4 (ref), TimeToInteractiveTracker (copy), buildTTIMetadata (copy), Cryo (copy)
		local v39 = t2[p4]

		if v39 and v39.started then
			v3:debug("TTI Start ignored: {} (reason=already_started, eventName={})", p4, v39.eventName)

			return false
		end

		local v40 = t12[p4]

		if v40.onStart then
			v40.onStart(t15)
		end

		local v41 = v40.getColdStart(t15)
		local v42 = if not v40.useBaseName then AppChatPerfEventInfo.buildTTIEventName(p4, t4.placement, v41) else AppChatPerfEventInfo.getTTIBaseName(p4)

		t2[p4] = {
			started = true,
			interactive = false,
			interactiveTimestamp = nil,
			eventName = v42
		}
		v3:debug("TTI Start: {} (coldStart={}, conversationId={}, entryPoint={})", v42, v41, t15.conversationId, t15.entryPoint)
		TimeToInteractiveTracker.trackStart(v42)
		TimeToInteractiveTracker.updateMetadata(v42, buildTTIMetadata(p4, Cryo.Dictionary.join(t15, {
			coldStart = v41
		})))

		return true
	end,
	finish = function(p5, t16: {[any]: any}) -- line: 243
		-- upvalues: t12 (copy), t2 (copy), t1 (copy), v3 (copy), TimeToInteractiveTracker (copy), buildTTIMetadata (copy), Milestone (copy)
		local v45 = t12[p5]

		if not t2[p5] then
			t2[p5] = table.clone(t1)
		end

		local v46 = t2[p5]

		if not v46.started then
			v3:debug("TTI End ignored: {} (reason=not_started)", p5)

			return false
		end

		local v47, v48 = v45.isContextMatching(t16)

		if not v47 then
			v3:debug("TTI End ignored: {} (reason={})", p5, v48 or "unknown")

			return false
		end

		local eventName = v46.eventName

		if eventName == nil then
			v3:debug("TTI End ignored: {} (reason=missing_event_name)", p5)

			return false
		end

		v3:debug("TTI End: {} (numElementsRendered={})", eventName, t16.numElementsRendered)
		TimeToInteractiveTracker.updateMetadata(eventName, buildTTIMetadata(p5, t16))

		if TimeToInteractiveTracker.trackMilestone then
			TimeToInteractiveTracker.trackMilestone(eventName, Milestone.SurfaceReady)
		end

		TimeToInteractiveTracker.trackEnd(eventName)
		v46.started = false

		if not v45.noInteractiveState then
			v46.interactive = true
			v46.interactiveTimestamp = os.clock()
		end

		v46.eventName = nil

		return true
	end,
	cancel = function(p6, _: {[any]: any}) -- line: 282
		-- upvalues: t2 (copy), t1 (copy), v3 (copy), TimeToInteractiveTracker (copy)
		if not t2[p6] then
			t2[p6] = table.clone(t1)
		end

		local v52 = t2[p6]

		if not v52.started then
			v3:debug("TTI Cancel ignored: {} (reason=not_started)", p6)

			return false
		end

		local eventName = v52.eventName

		if eventName == nil then
			v3:debug("TTI Cancel ignored: {} (reason=missing_event_name)", p6)

			return false
		end

		v3:debug("TTI Cancel: {}", eventName)
		TimeToInteractiveTracker.resetEvent(eventName)
		v52.started = false
		v52.interactive = false
		v52.interactiveTimestamp = nil
		v52.eventName = nil

		return true
	end,
	isActive = function(p7, t18: {[any]: any}) -- line: 306
		-- upvalues: t12 (copy), t2 (copy), t1 (copy)
		local v56 = t12[p7]

		if not t2[p7] then
			t2[p7] = table.clone(t1)
		end

		if not t2[p7].started then
			return false
		end

		return (v56.isContextMatching(t18))
	end,
	trackMilestone = function(p8, p9, t19: {[any]: any}) -- line: 320
		-- upvalues: TimeToInteractiveTracker (copy), t12 (copy), t2 (copy), t1 (copy), v3 (copy)
		if not TimeToInteractiveTracker.trackMilestone then
			return false
		end

		local v60 = t12[p8]

		if not t2[p8] then
			t2[p8] = table.clone(t1)
		end

		local v61 = t2[p8]

		if not v61.started or not v61.eventName then
			return false
		end

		if not v60.isContextMatching(t19) then
			return false
		end

		v3:debug("TTI Milestone: {} -> {}", v61.eventName, p9)
		TimeToInteractiveTracker.trackMilestone(v61.eventName, p9)

		return true
	end,
	trackSubphase = function(p10, p11, p12, t20: {[any]: any}) -- line: 338
		-- upvalues: TimeToInteractiveTracker (copy), t12 (copy), t2 (copy), t1 (copy), v3 (copy)
		if not TimeToInteractiveTracker.trackSubphase then
			return false
		end

		local v66 = t12[p10]

		if not t2[p10] then
			t2[p10] = table.clone(t1)
		end

		local v67 = t2[p10]

		if not v67.started or not v67.eventName then
			return false
		end

		if not v66.isContextMatching(t20) then
			return false
		end

		v3:debug("TTI Subphase: {} -> {}.{}", v67.eventName, p11, p12)
		TimeToInteractiveTracker.trackSubphase(v67.eventName, p11, p12)

		return true
	end,
	trackRequest = function(p13, p14, s1: string, t21: {[any]: any}) -- line: 361
		-- upvalues: TimeToInteractiveTracker (copy), t12 (copy), t2 (copy), t1 (copy), v3 (copy)
		if not TimeToInteractiveTracker.trackRequest then
			return false
		end

		local v72 = t12[p13]

		if not t2[p13] then
			t2[p13] = table.clone(t1)
		end

		local v73 = t2[p13]

		if not v73.started or not v73.eventName then
			return false
		end

		if not v72.isContextMatching(t21) then
			return false
		end

		v3:debug("TTI Request: {} -> {}.{}", v73.eventName, p14, s1)
		TimeToInteractiveTracker.trackRequest(v73.eventName, p14, s1)

		return true
	end,
	getEventName = function(p15) -- line: 386
		-- upvalues: t2 (copy), t1 (copy)
		if not t2[p15] then
			t2[p15] = table.clone(t1)
		end

		local v75 = t2[p15]

		if v75.started then
			return v75.eventName
		end

		return nil
	end,
	Milestone = Milestone,
	Hooks = TimeToInteractiveTracker.Hooks,
	isInteractive = function(p16) -- line: 398
		-- upvalues: t2 (copy), t1 (copy)
		if not t2[p16] then
			t2[p16] = table.clone(t1)
		end

		return t2[p16].interactive
	end,
	getInteractiveTimestamp = function(p17) -- line: 402
		-- upvalues: t2 (copy), t1 (copy)
		if not t2[p17] then
			t2[p17] = table.clone(t1)
		end

		return t2[p17].interactiveTimestamp
	end
}
