local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Logger = require(AppChat.Logger)
local v = Logger:new("AppChatPerf")
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local Milestone = timeToInteractiveTracker.Milestone
local PageGate = require(parent.PageGate)
local FFlagEnablePLTPrefetchCallbacks = PageGate.FFlagEnablePLTPrefetchCallbacks
local Cryo = require(parent.Cryo)
require(parent.SocialCommon)

local AppChatPerfEventInfo = require(AppChat.Telemetry.AppChatPerfEventInfo)
require(AppChat.Contexts.ChatPlacementContext)

local v2 = { started = false, interactive = false, interactiveTimestamp = nil, eventName = nil }

local v3 = {}

local function getTTIState(p) -- 9 equivalent calls inferred from this helper
	if not v3[p] then
		v3[p] = table.clone(v2)
	end

	return v3[p]
end

local v4 = nil
local conversationIdSet = {}

local joined = { category = 0 }
joined.category = AppChatPerfEventInfo.TTI_CATEGORY

local v5 = nil

local function alwaysMatch(_): (boolean, nil)
	return true, nil
end

local function matchConversation(p): (boolean, nil | string)
	if p.conversationId and v4 and p.conversationId ~= v4 then
		return false, "conversation_id_mismatch"
	end

	return true, nil
end

local function onStartConversation(p)
	local conversationId = p.conversationId

	if conversationId ~= nil and conversationId ~= v4 then
		v4 = conversationId

		if v5 then
			v5("ChatConversationTTI")
		end
	end
end

local function noColdStart(_): boolean
	return false
end

local v6 = {
	getColdStart = noColdStart,
	isContextMatching = matchConversation,
	useBaseName = true,
	noInteractiveState = true
}

local v7 = {
	ChatLandingTTI = {
		getColdStart = function(p): boolean
			return p.coldStart == true
		end,
		isContextMatching = alwaysMatch
	},
	ChatConversationTTI = {
		getColdStart = function(p)
			local conversationId = p.conversationId
			local coldStart

			if conversationId == nil then
				coldStart = false
			else
				coldStart = not conversationIdSet[conversationId]
			end

			if conversationId then
				conversationIdSet[conversationId] = true
			end

			return coldStart
		end,
		isContextMatching = matchConversation,
		onStart = onStartConversation
	},
	MessageSendTTI = v6,
	MessageReceiveTTI = v6
}

local function buildTTIMetadata(p, options)
	local ttiPage = AppChatPerfEventInfo.getTTIPage(p)
	return Cryo.Dictionary.join(joined, { subcategory = ttiPage, page = ttiPage }, options or {})
end

local AppChatTTITracker = {}

function AppChatTTITracker.setSharedContext(data)
	joined = Cryo.Dictionary.join(joined, data)
	v:debug(
		"Shared context updated: placement={}, entryPoint={}, hasActiveParty={}",
		data.placement or "nil",
		data.entryPoint or "nil",
		data.hasActiveParty or false
	)
end

function AppChatTTITracker.getSharedContext()
	return joined
end

function AppChatTTITracker.setOnConversationSwitch(callback)
	v5 = callback
end

function AppChatTTITracker.start(p, p2): boolean
	local v8 = v3[p]

	if v8 and v8.started then
		v:debug("TTI Start ignored: {} (reason=already_started, eventName={})", p, v8.eventName)
		return false
	end

	local v9 = v7[p]

	if v9.onStart then
		v9.onStart(p2)
	end

	local coldStart = v9.getColdStart(p2)
	local eventName

	if v9.useBaseName then
		eventName = AppChatPerfEventInfo.getTTIBaseName(p)
	else
		eventName = AppChatPerfEventInfo.buildTTIEventName(p, joined.placement, coldStart)
	end

	v3[p] = {
		started = true,
		interactive = false,
		interactiveTimestamp = nil,
		eventName = eventName
	}

	v:debug(
		"TTI Start: {} (coldStart={}, conversationId={}, entryPoint={})",
		eventName,
		coldStart,
		p2.conversationId,
		p2.entryPoint
	)

	timeToInteractiveTracker.trackStart(eventName)
	timeToInteractiveTracker.updateMetadata(
		eventName,
		buildTTIMetadata(p, Cryo.Dictionary.join(p2, { coldStart = coldStart }))
	)

	return true
end

function AppChatTTITracker.finish(p, p2): boolean
	local v8 = v7[p]
	local ttiState = getTTIState(p) -- inferred equivalent call

	if not ttiState.started then
		v:debug("TTI End ignored: {} (reason=not_started)", p)
		return false
	end

	local contextMatching, v9 = v8.isContextMatching(p2)

	if not contextMatching then
		v:debug("TTI End ignored: {} (reason={})", p, v9 or "unknown")
		return false
	end

	local eventName = ttiState.eventName

	if eventName == nil then
		v:debug("TTI End ignored: {} (reason=missing_event_name)", p)
		return false
	end

	v:debug("TTI End: {} (numElementsRendered={})", eventName, p2.numElementsRendered)
	timeToInteractiveTracker.updateMetadata(eventName, buildTTIMetadata(p, p2))

	if timeToInteractiveTracker.trackMilestone then
		timeToInteractiveTracker.trackMilestone(eventName, Milestone.SurfaceReady)
	end

	if FFlagEnablePLTPrefetchCallbacks and p == "ChatLandingTTI" then
		PageGate.signal(PageGate.Page.Party, PageGate.Milestone.SurfaceReady)
	end

	timeToInteractiveTracker.trackEnd(eventName)

	ttiState.started = false

	if not v8.noInteractiveState then
		ttiState.interactive = true
		ttiState.interactiveTimestamp = os.clock()
	end

	ttiState.eventName = nil
	return true
end

function AppChatTTITracker.cancel(p, _): boolean
	local ttiState = getTTIState(p) -- inferred equivalent call

	if not ttiState.started then
		v:debug("TTI Cancel ignored: {} (reason=not_started)", p)
		return false
	end

	local eventName = ttiState.eventName

	if eventName == nil then
		v:debug("TTI Cancel ignored: {} (reason=missing_event_name)", p)
		return false
	end

	v:debug("TTI Cancel: {}", eventName)
	timeToInteractiveTracker.resetEvent(eventName)

	ttiState.started = false
	ttiState.interactive = false
	ttiState.interactiveTimestamp = nil
	ttiState.eventName = nil
	return true
end

function AppChatTTITracker.isActive(p, p2)
	local v8 = v7[p]

	if getTTIState(p).started then -- inferred equivalent call
		return (v8.isContextMatching(p2))
	end

	return false
end

function AppChatTTITracker.trackMilestone(p, p2, p3): boolean
	if not timeToInteractiveTracker.trackMilestone then
		return false
	end

	local v8 = v7[p]
	local ttiState = getTTIState(p) -- inferred equivalent call

	if not (ttiState.started and ttiState.eventName and v8.isContextMatching(p3)) then
		return false
	end

	v:debug("TTI Milestone: {} -> {}", ttiState.eventName, p2)
	timeToInteractiveTracker.trackMilestone(ttiState.eventName, p2)
	return true
end

function AppChatTTITracker.trackSubphase(p, p2, p3, p4): boolean
	if not timeToInteractiveTracker.trackSubphase then
		return false
	end

	local v8 = v7[p]
	local ttiState = getTTIState(p) -- inferred equivalent call

	if not (ttiState.started and ttiState.eventName and v8.isContextMatching(p4)) then
		return false
	end

	v:debug("TTI Subphase: {} -> {}.{}", ttiState.eventName, p2, p3)
	timeToInteractiveTracker.trackSubphase(ttiState.eventName, p2, p3)
	return true
end

function AppChatTTITracker.trackRequest(p, p2, p3: string, p4): boolean
	if not timeToInteractiveTracker.trackRequest then
		return false
	end

	local v8 = v7[p]
	local ttiState = getTTIState(p) -- inferred equivalent call

	if not (ttiState.started and ttiState.eventName and v8.isContextMatching(p4)) then
		return false
	end

	v:debug("TTI Request: {} -> {}.{}", ttiState.eventName, p2, p3)
	timeToInteractiveTracker.trackRequest(ttiState.eventName, p2, p3)
	return true
end

function AppChatTTITracker.getEventName(p)
	local ttiState = getTTIState(p) -- inferred equivalent call
	return if ttiState.started then ttiState.eventName else nil
end

AppChatTTITracker.Milestone = Milestone
AppChatTTITracker.Hooks = timeToInteractiveTracker.Hooks

function AppChatTTITracker.isInteractive(p)
	return getTTIState(p).interactive -- inferred equivalent call
end

function AppChatTTITracker.getInteractiveTimestamp(p)
	return getTTIState(p).interactiveTimestamp -- inferred equivalent call
end

return AppChatTTITracker
