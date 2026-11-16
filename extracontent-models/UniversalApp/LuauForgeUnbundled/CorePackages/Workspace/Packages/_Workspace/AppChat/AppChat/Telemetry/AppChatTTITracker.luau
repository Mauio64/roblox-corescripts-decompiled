local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChatPerf")
local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/TimeToInteractiveTracker").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone
local PageGate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PageGate")
local fFlagEnablePLTPrefetchCallbacks = PageGate.FFlagEnablePLTPrefetchCallbacks
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")

local AppChatPerfEventInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfEventInfo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")

local v6 = {
	started = false,
	interactive = false,
	interactiveTimestamp = nil,
	eventName = nil
}

local v7 = {}

local function getTTIState(p2)
	if not v7[p2] then
		v7[p2] = table.clone(v6)
	end

	return v7[p2]
end

local v8 = nil
local conversationIdSet = {}

local joined = { category = 0 }
joined.category = AppChatPerfEventInfo.TTI_CATEGORY

local v9 = nil

local function alwaysMatch(p2): (boolean, nil)
	return true, nil
end

local function matchConversation(p2): (boolean, nil | string)
	if p2.conversationId and v8 and p2.conversationId ~= v8 then
		return false, "conversation_id_mismatch"
	end

	return true, nil
end

local function onStartConversation(p2)
	local conversationId = p2.conversationId

	if conversationId ~= nil and conversationId ~= v8 then
		v8 = conversationId

		if v9 then
			v9("ChatConversationTTI")
		end
	end
end

local function noColdStart(p2): boolean
	return false
end

local v10 = {
	getColdStart = noColdStart,
	isContextMatching = matchConversation,
	useBaseName = true,
	noInteractiveState = true
}

local v11 = {
	ChatLandingTTI = {
		getColdStart = function(p2): boolean
			return p2.coldStart == true
		end,
		isContextMatching = alwaysMatch
	},
	ChatConversationTTI = {
		getColdStart = function(p2)
			local conversationId = p2.conversationId
			local coldStart = not (conversationId == nil) and not conversationIdSet[conversationId]

			if conversationId then
				conversationIdSet[conversationId] = true
			end

			return coldStart
		end,
		isContextMatching = matchConversation,
		onStart = onStartConversation
	},
	MessageSendTTI = v10,
	MessageReceiveTTI = v10
}

local function buildTTIMetadata(p2, options)
	local ttiPage = AppChatPerfEventInfo.getTTIPage(p2)
	return Cryo.Dictionary.join(joined, { subcategory = ttiPage, page = ttiPage }, options or {})
end

return {
	setSharedContext = function(data)
		joined = Cryo.Dictionary.join(joined, data)
		v5:debug(
			"Shared context updated: placement={}, entryPoint={}, hasActiveParty={}",
			data.placement or "nil",
			data.entryPoint or "nil",
			data.hasActiveParty or false
		)
	end,
	getSharedContext = function()
		return joined
	end,
	setOnConversationSwitch = function(p2)
		v9 = p2
	end,
	start = function(p2, p3): boolean
		local v12 = v7[p2]

		if v12 and v12.started then
			v5:debug("TTI Start ignored: {} (reason=already_started, eventName={})", p2, v12.eventName)
			return false
		end

		local v13 = v11[p2]

		if v13.onStart then
			v13.onStart(p3)
		end

		local coldStart = v13.getColdStart(p3)
		local v14

		if v13.useBaseName then
			v14 = AppChatPerfEventInfo.getTTIBaseName(p2)
		else
			v14 = AppChatPerfEventInfo.buildTTIEventName(p2, joined.placement, coldStart)
		end

		v7[p2] = {
			started = true,
			interactive = false,
			interactiveTimestamp = nil,
			eventName = v14
		}

		v5:debug(
			"TTI Start: {} (coldStart={}, conversationId={}, entryPoint={})",
			v14,
			coldStart,
			p3.conversationId,
			p3.entryPoint
		)

		timeToInteractiveTracker.trackStart(v14)
		timeToInteractiveTracker.updateMetadata(
			v14,
			buildTTIMetadata(p2, Cryo.Dictionary.join(p3, { coldStart = coldStart }))
		)

		return true
	end,
	finish = function(p2, p3): boolean
		local v12 = v11[p2]

		if not v7[p2] then
			v7[p2] = table.clone(v6)
		end

		local v13 = v7[p2]

		if not v13.started then
			v5:debug("TTI End ignored: {} (reason=not_started)", p2)
			return false
		end

		local contextMatching, v14 = v12.isContextMatching(p3)

		if not contextMatching then
			v5:debug("TTI End ignored: {} (reason={})", p2, v14 or "unknown")
			return false
		end

		local eventName = v13.eventName

		if eventName == nil then
			v5:debug("TTI End ignored: {} (reason=missing_event_name)", p2)
			return false
		end

		v5:debug("TTI End: {} (numElementsRendered={})", eventName, p3.numElementsRendered)
		timeToInteractiveTracker.updateMetadata(eventName, buildTTIMetadata(p2, p3))

		if timeToInteractiveTracker.trackMilestone then
			timeToInteractiveTracker.trackMilestone(eventName, milestone.SurfaceReady)
		end

		if fFlagEnablePLTPrefetchCallbacks and p2 == "ChatLandingTTI" then
			PageGate.signal(PageGate.Page.Party, PageGate.Milestone.SurfaceReady)
		end

		timeToInteractiveTracker.trackEnd(eventName)

		v13.started = false

		if not v12.noInteractiveState then
			v13.interactive = true
			v13.interactiveTimestamp = os.clock()
		end

		v13.eventName = nil
		return true
	end,
	cancel = function(p2, p3): boolean
		if not v7[p2] then
			v7[p2] = table.clone(v6)
		end

		local v12 = v7[p2]

		if not v12.started then
			v5:debug("TTI Cancel ignored: {} (reason=not_started)", p2)
			return false
		end

		local eventName = v12.eventName

		if eventName == nil then
			v5:debug("TTI Cancel ignored: {} (reason=missing_event_name)", p2)
			return false
		end

		v5:debug("TTI Cancel: {}", eventName)
		timeToInteractiveTracker.resetEvent(eventName)

		v12.started = false
		v12.interactive = false
		v12.interactiveTimestamp = nil
		v12.eventName = nil
		return true
	end,
	isActive = function(p2, p3)
		local v12 = v11[p2]

		if not v7[p2] then
			v7[p2] = table.clone(v6)
		end

		if v7[p2].started then
			return (v12.isContextMatching(p3))
		end

		return false
	end,
	trackMilestone = function(p2, p3, p4): boolean
		if not timeToInteractiveTracker.trackMilestone then
			return false
		end

		local v12 = v11[p2]

		if not v7[p2] then
			v7[p2] = table.clone(v6)
		end

		local v13 = v7[p2]

		if not (v13.started and v13.eventName and v12.isContextMatching(p4)) then
			return false
		end

		v5:debug("TTI Milestone: {} -> {}", v13.eventName, p3)
		timeToInteractiveTracker.trackMilestone(v13.eventName, p3)
		return true
	end,
	trackSubphase = function(p2, p3, p4, p5): boolean
		if not timeToInteractiveTracker.trackSubphase then
			return false
		end

		local v12 = v11[p2]

		if not v7[p2] then
			v7[p2] = table.clone(v6)
		end

		local v13 = v7[p2]

		if not (v13.started and v13.eventName and v12.isContextMatching(p5)) then
			return false
		end

		v5:debug("TTI Subphase: {} -> {}.{}", v13.eventName, p3, p4)
		timeToInteractiveTracker.trackSubphase(v13.eventName, p3, p4)
		return true
	end,
	trackRequest = function(p2, p3, p4, p5): boolean
		if not timeToInteractiveTracker.trackRequest then
			return false
		end

		local v12 = v11[p2]

		if not v7[p2] then
			v7[p2] = table.clone(v6)
		end

		local v13 = v7[p2]

		if not (v13.started and v13.eventName and v12.isContextMatching(p5)) then
			return false
		end

		v5:debug("TTI Request: {} -> {}.{}", v13.eventName, p3, p4)
		timeToInteractiveTracker.trackRequest(v13.eventName, p3, p4)
		return true
	end,
	getEventName = function(p2)
		if not v7[p2] then
			v7[p2] = table.clone(v6)
		end

		local v12 = v7[p2]

		if v12.started then
			return v12.eventName
		end

		return nil
	end,
	["Milestone"] = milestone,
	Hooks = timeToInteractiveTracker.Hooks,
	isInteractive = function(p2)
		if not v7[p2] then
			v7[p2] = table.clone(v6)
		end

		return v7[p2].interactive
	end,
	getInteractiveTimestamp = function(p2)
		if not v7[p2] then
			v7[p2] = table.clone(v6)
		end

		return v7[p2].interactiveTimestamp
	end
}
