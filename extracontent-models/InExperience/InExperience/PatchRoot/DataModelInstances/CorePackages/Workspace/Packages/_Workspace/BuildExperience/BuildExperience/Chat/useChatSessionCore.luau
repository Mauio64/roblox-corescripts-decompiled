local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local MessageBusService = game:GetService("MessageBusService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local UniverseCreate = require(BuildExperienceParent.DataHydration.UniverseCreate)
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)
local React = require(BuildExperienceParent.React)
local ReactUtils = require(BuildExperienceParent.ReactUtils)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

require(script.Parent.chatTypes)

local creatorAgentChat = require(script.Parent.creatorAgentChat)
local parseSessionStream = require(script.Parent.parseSessionStream)
local useChatScroll = require(script.Parent.useChatScroll)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)

require(BuildExperience.Stores.GetPlaytestLoadingStore.createPlaytestLoadingStore)

local getDefaultTemplatePlaceId = require(BuildExperience.utils.getDefaultTemplatePlaceId)
local launchPlaytestWithLoadingState = require(BuildExperience.utils.launchPlaytestWithLoadingState)
local debug = CreatorAgentChat.debug
local CHAT_CREATE_UNIVERSE_ERROR = LocalizationStrings.CHAT_CREATE_UNIVERSE_ERROR
local MessageId = MessageBusService:GetMessageId("Game", "onGameLeave")
local t1 = {
	submittedToolCallIds = {},
	askUserByToolCallId = {},
	planByToolCallId = {}
}
local t2 = {
	onAnswerSelectedByToolCallId = {},
	onAnswerConfirmedByToolCallId = {},
	onPlanAcceptedByToolCallId = {}
}
local v25 = Signals.createSignal(t1)
local v26 = Signals.createSignal(t2)
local v27 = Signals.createSignal(nil)
local v28 = Signals.createSignal({
	session = nil,
	sessionId = nil,
	events = {}
})

local function sessionOwnerMatches(t3: {[any]: any}?, p1, s1: string?) -- line: 130
	if t3 == nil or p1 ~= t3.session then
		return false
	end

	if s1 == nil or s1 == "" then
		return true
	end

	return s1 == t3.sessionId or t3.sessionId == nil and s1 == t3.session.getCasSessionId()
end
local function hasPendingLocalToolResponse(p2) -- line: 140
	for v40 in p2.askUserByToolCallId do
		if not p2.submittedToolCallIds[v40] then
			return true
		end
	end

	for v41 in p2.planByToolCallId do
		if not p2.submittedToolCallIds[v41] then
			return true
		end
	end

	return false
end
local function trimMessage(s2: string) -- line: 154
	return string.gsub(s2, "^%s*(.-)%s*$", "%1")
end
local function refreshVersionHistoryAfterPublish(n1: number?) -- line: 158
	-- upvalues: PlaceVersionHistory (copy)
	if n1 == nil then
		return
	end

	PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(n1)
end
local function scheduleComposerAutoFocus(t4: {[any]: any}, p3: ((...any) -> ...any)) -- line: 165
	local n2 = 8

	local function tryFocus() -- line: 167
		-- upvalues: p3 (copy), t4 (copy), n2 (ref), tryFocus (copy)
		if p3() then
			return
		end

		local current = t4.current

		if current then
			current.focus()

			return
		end

		n2 -= 1

		if n2 > 0 then
			task.delay(0, tryFocus)
		end
	end

	task.defer(tryFocus)
end
local function getResumeSessionKey(p4) -- line: 184
	local v49 = p4.getCasSessionId()

	if typeof(v49) == "string" and v49 ~= "" then
		return v49
	end

	local universeId = p4.universeId
	local placeId = p4.placeId

	if universeId ~= nil and placeId ~= nil then
		return `{ universeId }:{ placeId }`
	end

	return nil
end
local function useChatSessionCore(t5: {[any]: any}) -- line: 197
	-- upvalues: React (copy), CreatorAgentChat (copy), v28 (copy), Signals (copy), SignalsReact (copy), v25 (copy), v26 (copy), v27 (copy), parseSessionStream (copy), hasPendingLocalToolResponse (copy), PlaceVersionHistory (copy), ReactUtils (copy), useChatScroll (copy), GetPlaytestLoadingStore (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy), creatorAgentChat (copy), UniverseCreate (copy), getDefaultTemplatePlaceId (copy), debug (copy), UniverseConfiguration (copy), CHAT_CREATE_UNIVERSE_ERROR (copy), launchPlaytestWithLoadingState (copy)
	local v53, v54 = React.useState(nil)
	local v55, v56 = React.useState(nil)
	local placeId = t5.placeId
	local universeId = t5.universeId
	local sessionId = t5.sessionId

	if v53 ~= nil then
		placeId = v53.placeId
		universeId = v53.universeId
		sessionId = v53.sessionId
	end

	if (sessionId == nil or sessionId == "") and v55 ~= nil and v55.universeId == universeId and v55.placeId == placeId then
		sessionId = v55.sessionId
	end

	local v60 = t5.hydrateHistoryWhen == nil or t5.hydrateHistoryWhen
	local v61 = CreatorAgentChat.getCreatorAgentChatStore()
	local v62 = React.useMemo(function() -- line: 219
		-- upvalues: universeId (ref), v61 (copy), placeId (ref), sessionId (ref)
		if universeId == nil then
			return nil
		end

		return v61.getSessionForProject(universeId, placeId, sessionId)
	end, {
		universeId,
		placeId,
		sessionId,
		v61
	})

	React.useLayoutEffect(function() -- line: 226
		-- upvalues: v62 (copy), sessionId (ref)
		if v62 == nil or (sessionId == nil or sessionId == "") then
			return
		end

		v62.setCasSessionId(sessionId)
	end, {
		v62,
		sessionId
	})

	local v63 = React.useMemo(function() -- line: 233
		-- upvalues: v62 (copy), v28 (copy), Signals (copy)
		if v62 == nil then
			return v28
		end

		return (Signals.createComputed(function(p5) -- line: 238
			-- upvalues: v62 (copy)
			return {
				session = v62,
				sessionId = v62.getCasSessionId(),
				events = v62.getMergedHistory(p5)
			}
		end))
	end, { v62 })
	local v64 = SignalsReact.useSignalState(v63)
	local v65 = if v62 == nil then nil else v62.getCasSessionId()
	local v66 = if v62 ~= v64.session or v65 ~= v64.sessionId then {} else v64.events
	local v67, v68 = React.useState(nil)
	local v69, v70 = React.useState(nil)

	React.useEffect(function() -- line: 268
		-- upvalues: v70 (copy)
		v70(nil)
	end, {
		v62,
		sessionId
	})

	local v71 = sessionId
	local v72 = if not (v69 ~= nil and (v62 == v69.session and (v71 == nil or (v71 == "" or (v71 == v69.sessionId or v69.sessionId == nil and v71 == v69.session.getCasSessionId()))))) then nil else v69
	local v73, v74 = React.useState(nil)
	local v75 = React.useRef(nil)
	local v76 = React.useRef(nil)
	local v77 = React.useRef(0)
	local v78 = React.useRef(nil)
	local v79 = React.useCallback(function(p6, p7) -- line: 283
		-- upvalues: v75 (copy), v76 (copy), v74 (copy)
		assert(p6 == nil or p7 ~= nil, "Active turns require an owning session")
		v75.current = p6
		v76.current = if p6 == nil then nil else {
			session = p7,
			sessionId = p7.getCasSessionId()
		}
		v74(p6)
	end, { v74 })
	local current = v76.current
	local v81 = sessionId
	local v82 = if not (current ~= nil and (v62 == current.session and (v81 == nil or (v81 == "" or (v81 == current.sessionId or current.sessionId == nil and v81 == current.session.getCasSessionId()))))) then nil else v73

	React.useLayoutEffect(function() -- line: 300
		-- upvalues: v73 (copy), v76 (copy), v62 (copy), sessionId (ref), v77 (copy), v78 (copy), v79 (copy), v68 (copy), v70 (copy)
		if v73 ~= nil then
			local current2 = v76.current
			local v125 = v62
			local v126 = sessionId

			if not (current2 ~= nil and (v125 == current2.session and (v126 == nil or (v126 == "" or (v126 == current2.sessionId or current2.sessionId == nil and v126 == current2.session.getCasSessionId()))))) then
				local v127 = v77

				v127.current = v127.current + 1
				v78.current = nil
				v73.detach()
				v79(nil, nil)
				v68(nil)
				v70(nil)

				return
			end
		end
	end, {
		v62,
		sessionId,
		v73,
		v79
	})

	local v83 = if v82 == nil then v25 else v82.getOptimisticLocalTools
	local v84 = if v82 == nil then v26 else v82.getLocalToolActions
	local v85 = if v82 == nil then v27 else v82.getSetupErrorText
	local v86 = SignalsReact.useSignalState(v83)
	local v87 = SignalsReact.useSignalState(v84)
	local v88 = SignalsReact.useSignalState(v85)
	local v89 = React.useMemo(function() -- line: 328
		-- upvalues: v82 (copy), v88 (copy)
		if v82 == nil then
			return nil
		end

		return {
			setupErrorText = v88
		}
	end, {
		v82,
		v88
	})
	local v90 = React.useMemo(function() -- line: 336
		-- upvalues: parseSessionStream (copy), v66 (copy), v62 (copy), sessionId (ref), universeId (ref), placeId (ref), v86 (copy), v67 (copy), v89 (copy), v72 (copy)
		return parseSessionStream(v66, {
			sessionId = if v62 == nil then sessionId else v62.getCasSessionId() or sessionId,
			universeId = if v62 == nil then universeId else v62.universeId,
			placeId = if v62 == nil then placeId else v62.placeId,
			optimisticLocalTools = v86,
			pendingUserMessage = if v67 == nil then nil else v67.text,
			pendingUserMessageAfterSequenceId = if v67 == nil then nil else v67.afterSequenceId,
			liveAssistantMessage = v89,
			optimisticCancelledStartSequenceId = if v72 == nil then nil else v72.startSequenceId
		})
	end, {
		v66,
		v62,
		sessionId,
		universeId,
		placeId,
		v86,
		v67,
		v89,
		v72
	})
	local messages = v90.messages
	local subagentTaskState = v90.subagentTaskState
	local includesPublishTool = v90.includesPublishTool
	local v94 = messages[#messages]
	local v95 = v82 ~= nil or v94 ~= nil and (v94.kind == "assistant_turn" and not v94.isDone)
	local v96 = v95 and hasPendingLocalToolResponse(v86)
	local activeTurnState = v90.activeTurnState

	React.useEffect(function() -- line: 379
		-- upvalues: v82 (copy), activeTurnState (copy)
		if v82 == nil or activeTurnState == nil then
			return
		end

		v82.syncFromTurnState(activeTurnState)
	end, {
		v82,
		activeTurnState
	})
	React.useEffect(function() -- line: 386
		-- upvalues: v90 (copy), placeId (ref), PlaceVersionHistory (copy)
		if not v90.includesPublishTool then
			return
		end

		local v128 = placeId

		if v128 == nil then
			return
		end

		PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(v128)
	end, {
		v90.includesPublishTool,
		placeId
	})

	local v98, v99 = React.useBinding("")
	local v100, v101 = React.useState(nil)
	local v102 = React.useRef("")
	local v103 = React.useRef(nil)
	local v104 = ReactUtils.useClock()
	local v105 = useChatScroll()
	local v106 = React.useCallback(function(n3: number, p8) -- line: 401
		-- upvalues: GetPlaytestLoadingStore (copy)
		GetPlaytestLoadingStore().setAgentStatusForPlaceId(n3, p8)
	end, {})
	local v107 = React.useCallback(function(p9: ((...any) -> ...any)?) -- line: 405
		-- upvalues: v105 (copy), v62 (copy)
		local function v132() -- line: 406
			-- upvalues: p9 (copy)
			if p9 ~= nil then
				return p9()
			end

			return false
		end

		v105.captureDistanceFromBottom()
		task.spawn(function() -- line: 413
			-- upvalues: v62 (copy), v132 (copy), v105 (copy), p9 (copy)
			if v62 == nil then
				return
			end

			if v62.loadOlderHistory(v132) and v62.getNextHistoryPageToken() ~= nil and v105.isAtTopRef.current then
				task.delay(0.1, function() -- line: 419
					-- upvalues: p9 (copy), v105 (copy), v62 (copy), v132 (copy)
					if p9 ~= nil and p9() then
						return
					end

					if v105.isViewportUnderfilled() then
						v62.loadOlderHistory(v132)
					end
				end)
			end
		end)
	end, {
		v62,
		v105
	})
	local v108 = React.useCallback(function(p10: ((...any) -> ...any)) -- line: 431
		-- upvalues: v62 (copy), v105 (copy), v107 (copy)
		task.delay(0.1, function() -- line: 432
			-- upvalues: p10 (copy), v62 (copy), v105 (copy), v107 (copy)
			if p10() then
				return
			end

			if v62 == nil then
				return
			end

			if v62.getNextHistoryPageToken() == nil then
				return
			end

			if not v105.isViewportUnderfilled() then
				return
			end

			v107(p10)
		end)
	end, {
		v107,
		v105,
		v62
	})
	local v109 = React.useCallback(function(p11: ((...any) -> ...any)) -- line: 450
		-- upvalues: v62 (copy), v108 (copy)
		if v62 == nil then
			return
		end

		if v62.getNextHistoryPageToken() == nil then
			return
		end

		v108(p11)
	end, {
		v108,
		v62
	})
	local v110 = React.useRef(v109)

	v110.current = v109
	React.useEffect(function() -- line: 462
		-- upvalues: v105 (copy), v107 (copy)
		v105.setOnScrolledToTop(function() -- line: 463
			-- upvalues: v107 (copy)
			v107(nil)
		end)

		return function() -- line: 466
			-- upvalues: v105 (copy)
			v105.setOnScrolledToTop(nil)
		end
	end, {
		v105.setOnScrolledToTop,
		v107
	})
	React.useEffect(function() -- line: 471
		-- upvalues: v60 (copy), v62 (copy), sessionId (ref), v110 (copy), universeId (ref), v61 (copy), v56 (copy), placeId (ref)
		if not v60 or v62 == nil then
			return
		end

		local u135 = false
		local v136 = sessionId

		local function isHydrateCancelled() -- line: 478
			-- upvalues: u135 (ref), v136 (copy), v62 (copy)
			if u135 then
				return true
			end

			if v136 ~= nil and v136 ~= "" then
				return v62.getCasSessionId() ~= v136
			end

			return false
		end
		local function continueAfterSessionReady() -- line: 487
			-- upvalues: u135 (ref), v136 (copy), v62 (copy), v110 (copy), isHydrateCancelled (copy)
			if not not u135 or v136 ~= nil and (v136 ~= "" and v62.getCasSessionId() ~= v136) then
				return
			end

			v110.current(isHydrateCancelled)
		end
		local function hydrateKnownSession(s3: string) -- line: 494
			-- upvalues: v62 (copy), u135 (ref), v136 (copy), v110 (copy), isHydrateCancelled (copy)
			v62.setCasSessionId(s3)

			if v62.hasLoadedHistory() and #v62.getMergedHistory(false) > 0 then
				if not not u135 or v136 ~= nil and (v136 ~= "" and v62.getCasSessionId() ~= v136) then
					return
				end

				v110.current(isHydrateCancelled)

				return
			end

			if v62.refreshSession(isHydrateCancelled) and (not u135 and (v136 == nil or (v136 == "" or v62.getCasSessionId() == v136))) then
				if not not u135 or v136 ~= nil and (v136 ~= "" and v62.getCasSessionId() ~= v136) then
					return
				end

				v110.current(isHydrateCancelled)
			end
		end

		task.spawn(function() -- line: 505
			-- upvalues: sessionId (ref), hydrateKnownSession (copy), universeId (ref), v62 (copy), v61 (copy), u135 (ref), v136 (copy), v56 (copy), placeId (ref)
			if sessionId ~= nil and sessionId ~= "" then
				hydrateKnownSession(sessionId)

				return
			end

			if universeId == nil or universeId == 0 or v62.hasLoadedHistory() and #v62.getMergedHistory(false) > 0 then
				return
			end

			local v196 = v61.sessionFindByUniverse({
				sort = "desc",
				universeId = universeId
			})

			while v196.state(false).status == "pending" and (not u135 and (v136 == nil or (v136 == "" or v62.getCasSessionId() == v136))) do
				task.wait()
			end

			if u135 or v136 ~= nil and (v136 ~= "" and v62.getCasSessionId() ~= v136) or v196.state(false).status ~= "succeeded" then
				return
			end

			local result = v196.state(false).result
			local v198 = if result == nil then nil else result.sessions
			local v199 = if typeof(v198) ~= "table" then nil else v198[1]
			local v200 = if typeof(v199) ~= "table" then nil else v199.sessionId

			if typeof(v200) ~= "string" or v200 == "" then
				v62.markHistoryLoaded()

				return
			end

			v56({
				universeId = universeId,
				placeId = placeId,
				sessionId = v200
			})
		end)

		return function() -- line: 546
			-- upvalues: u135 (ref)
			u135 = true
		end
	end, {
		v62,
		sessionId,
		universeId,
		placeId,
		v61,
		v60
	})
	React.useEffect(function() -- line: 551
		-- upvalues: v62 (copy), sessionId (ref), v110 (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy)
		if v62 == nil then
			return
		end

		local u140 = false

		local function refreshKnownSession() -- line: 556
			-- upvalues: v62 (copy), sessionId (ref), u140 (ref), v110 (copy)
			local v201 = v62.getCasSessionId()

			if (v201 == nil or v201 == "") and (sessionId ~= nil and sessionId ~= "") then
				v201 = sessionId
			end

			if v201 == nil or v201 == "" then
				return
			end

			task.spawn(function() -- line: 564
				-- upvalues: v62 (copy), u140 (ref), v110 (copy)
				if v62.refreshSession(function() -- line: 565
					-- upvalues: u140 (ref)
					return u140
				end) and not u140 then
					v110.current(function() -- line: 568
						-- upvalues: u140 (ref)
						return u140
					end)
				end
			end)
		end

		local v142 = MessageBusService:Subscribe(MessageId, function(_) -- line: 575
			-- upvalues: refreshKnownSession (copy)
			refreshKnownSession()
		end, false, true)
		local connection = AppLifecycleObserverService.OnUnhide:Connect(refreshKnownSession)

		return function() -- line: 580
			-- upvalues: u140 (ref), v142 (copy), connection (copy)
			u140 = true
			v142:Disconnect()
			connection:Disconnect()
		end
	end, {
		v62,
		sessionId
	})

	local v111 = React.useCallback(function(s4: string) -- line: 587
		-- upvalues: v102 (copy), v99 (copy), v101 (copy)
		v102.current = s4
		v99(s4)
		v101(nil)
	end, {
		v99,
		v101
	})
	local v112 = React.useCallback(function(n4: number, p13, s5: string?, p14) -- line: 594
		-- upvalues: v77 (copy), v79 (copy), v78 (copy), v68 (copy), t5 (copy), v106 (copy), v111 (copy), v101 (copy), creatorAgentChat (copy), v105 (copy), sessionId (ref), v54 (copy)
		if n4 ~= v77.current then
			return
		end

		v79(nil)
		v78.current = nil
		v68(nil)

		if p13 ~= nil then
			if t5.onPromptFailure ~= nil then
				t5.onPromptFailure(p13.errorCode, p13.outOfCreditsReason)
			end

			if p14.placeId ~= nil then
				v106(p14.placeId, "Idle")
			end

			if s5 ~= nil then
				v111(s5)
				v101(creatorAgentChat.getPromptFailureComposerError(p13))
			end

			task.spawn(function() -- line: 621
				-- upvalues: p14 (copy), v77 (copy), n4 (copy)
				p14.refreshSession(function() -- line: 622
					-- upvalues: v77 (copy), n4 (copy)
					return v77.current ~= n4
				end)
			end)

			return
		end

		if p14.placeId ~= nil then
			v106(p14.placeId, "Completed")
		end

		v105.scrollToBottomAfterSend()

		local v149 = p14.getCasSessionId()

		if v149 ~= nil and v149 ~= "" then
			if t5.createUniverseOnFirstPrompt and sessionId == nil and p14.universeId ~= nil then
				local t6 = {
					universeId = p14.universeId,
					placeId = p14.placeId,
					sessionId = v149
				}

				v54(t6)

				if t5.onProjectResolved ~= nil then
					t5.onProjectResolved(t6)
				end
			end

			task.spawn(function() -- line: 650
				-- upvalues: p14 (copy), v77 (copy), n4 (copy)
				p14.refreshSession(function() -- line: 651
					-- upvalues: v77 (copy), n4 (copy)
					return v77.current ~= n4
				end)
			end)
		end
	end, {
		t5.createUniverseOnFirstPrompt,
		t5.onPromptFailure,
		t5.onProjectResolved,
		sessionId,
		v106,
		v54,
		v105,
		v111,
		v101,
		v79,
		v68
	})
	local v113 = React.useRef(v60)

	React.useEffect(function() -- line: 674
		-- upvalues: v60 (copy), v113 (copy), v95 (copy), v82 (copy), v105 (copy)
		local v151 = v60 and not v113.current

		v113.current = v60

		if not v60 then
			return
		end

		if not v151 and not v95 and v82 == nil then
			return
		end

		v105.scrollToBottomUnconditionally()
		task.defer(v105.scrollToBottomUnconditionally)
		task.delay(0.15, v105.scrollToBottomUnconditionally)
	end, {
		v60,
		v95,
		v82,
		#messages,
		v105
	})
	React.useEffect(function() -- line: 700
		-- upvalues: v75 (copy), v76 (copy), v62 (copy), sessionId (ref), v72 (copy), v77 (copy), v78 (copy), placeId (ref), v106 (copy), creatorAgentChat (copy), v112 (copy), v79 (copy), v105 (copy), v90 (copy), v82 (copy), v61 (copy), v95 (copy)
		if v75.current ~= nil then
			local current3 = v76.current
			local v153 = v62
			local v154 = sessionId

			if current3 ~= nil and (v153 == current3.session and (v154 == nil or (v154 == "" or (v154 == current3.sessionId or current3.sessionId == nil and v154 == current3.session.getCasSessionId())))) then
				return
			end
		end

		if v72 ~= nil then
			return
		end

		if v62 == nil then
			return
		end

		local v155 = v62
		local v156 = v155.getCasSessionId()

		if typeof(v156) == "string" and v156 ~= "" then
		else
			local universeId2 = v155.universeId
			local placeId2 = v155.placeId

			v156 = if universeId2 == nil or placeId2 == nil then nil else `{ universeId2 }:{ placeId2 }`
		end

		if v156 == nil then
			return
		end

		local function attachResumedTurn(p15, n5: number?) -- line: 722
			-- upvalues: v77 (copy), v78 (copy), placeId (ref), v106 (copy), creatorAgentChat (copy), v62 (copy), v112 (copy), v79 (copy), v105 (copy)
			local v205 = v77

			v205.current = v205.current + 1

			local current4 = v77.current

			v78.current = n5

			if placeId ~= nil then
				v106(placeId, "Loading")
			end

			local v207 = creatorAgentChat.createResumedAssistantTurn(v62, p15, function(p16) -- line: 732
				-- upvalues: v112 (copy), current4 (copy), v62 (copy)
				v112(current4, p16, nil, v62)
			end, if n5 == nil then nil else n5 - 1)

			v79(v207, v62)
			v207.start()
			v105.scrollToBottomUnconditionally()
		end

		if v90.activeTurnState ~= nil and v90.activeTurnItemIndex ~= nil and not v90.activeTurnState.isDone then
			local activeTurnStartSequenceId = v90.activeTurnStartSequenceId

			if activeTurnStartSequenceId == v78.current and v82 ~= nil then
				return
			end

			local v161 = v61.resumeTurnFromHistory(v156, v90.activeTurnState, v90.activeTurnSequenceIds)

			if v161 ~= nil then
				attachResumedTurn(v161, activeTurnStartSequenceId)
			end

			return
		end

		v78.current = nil

		local v162 = v61.getActiveTurnHandle(v156)
		local v163 = if v162 == nil then nil else v162.state(false)
		local v164 = v162 ~= nil and (v163 ~= nil and not v163.isDone)

		if not v95 and not v164 then
			return
		end

		if v164 then
			attachResumedTurn(v162, nil)
		end
	end, {
		v90,
		v62,
		sessionId,
		v61,
		v95,
		v82,
		placeId,
		v106,
		v112,
		v105,
		v79,
		v72
	})

	local v114 = React.useCallback(function(p17, s6: string, n6: number, n7: number?) -- line: 794
		-- upvalues: v68 (copy), creatorAgentChat (copy), v112 (copy), v106 (copy), v79 (copy), v105 (copy)
		v68({
			text = s6,
			afterSequenceId = n7
		})

		local v169 = creatorAgentChat.createLiveAssistantTurn(p17, s6, function(p18) -- line: 801
			-- upvalues: v112 (copy), n6 (copy), s6 (copy), p17 (copy)
			v112(n6, p18, s6, p17)
		end)

		if p17.placeId ~= nil then
			v106(p17.placeId, "Loading")
		end

		v79(v169, p17)
		v105.scrollToBottomAfterSend()
		v169.start()
	end, {
		v112,
		v106,
		v105,
		v79,
		v68
	})
	local v115 = React.useCallback(function(s7: string, n8: number, n9: number?) -- line: 823
		-- upvalues: v68 (copy), UniverseCreate (copy), getDefaultTemplatePlaceId (copy), debug (copy), v77 (copy), UniverseConfiguration (copy), v54 (copy), t5 (copy), v61 (copy), sessionId (ref), v114 (copy), v79 (copy), v111 (copy), v101 (copy), CHAT_CREATE_UNIVERSE_ERROR (copy)
		v68({
			text = s7,
			afterSequenceId = n9
		})

		local elapsed = os.clock()

		UniverseCreate.getUniverseCreateStore().createUniverse({
			isPublish = true,
			templatePlaceId = getDefaultTemplatePlaceId()
		}):andThen(function(p19) -- line: 831
			-- upvalues: debug (copy), elapsed (copy), v77 (copy), n8 (copy), UniverseConfiguration (copy), v54 (copy), t5 (copy), v61 (copy), sessionId (ref), v114 (copy), s7 (copy), n9 (copy)
			debug.log("info", "build_experience create_universe succeeded", {
				durationMs = math.floor((os.clock() - elapsed) * 1000 + 0.5),
				universeId = p19.universeId,
				rootPlaceId = p19.rootPlaceId
			})

			if v77.current ~= n8 then
				return nil
			end

			local v210 = UniverseConfiguration.getUniverseConfigurationStore()

			return v210.patchConfiguration(p19.universeId, {
				audiences = { 1 }
			}):andThen(function() -- line: 846
				-- upvalues: v210 (copy), p19 (copy)
				return v210.setTeamCreate(p19.universeId, true)
			end):andThen(function() -- line: 849
				-- upvalues: v77 (copy), n8 (copy), p19 (copy), v54 (copy), t5 (copy), v61 (copy), sessionId (ref), v114 (copy), s7 (copy), n9 (copy)
				if v77.current ~= n8 then
					return nil
				end

				local t7 = {
					universeId = p19.universeId,
					placeId = p19.rootPlaceId
				}

				v54(t7)

				if t5.onProjectResolved ~= nil then
					t5.onProjectResolved(t7)
				end

				local v215 = v61.getSessionForProject(p19.universeId, p19.rootPlaceId, sessionId)

				v114(v215, s7, n8, n9)

				return nil
			end)
		end):catch(function(p20) -- line: 872
			-- upvalues: debug (copy), elapsed (copy), v77 (copy), n8 (copy), v79 (copy), v68 (copy), v111 (copy), s7 (copy), v101 (copy), CHAT_CREATE_UNIVERSE_ERROR (copy)
			debug.log("warn", "build_experience create_or_configure_universe failed", {
				durationMs = math.floor((os.clock() - elapsed) * 1000 + 0.5),
				error = p20
			})

			if v77.current ~= n8 then
				return
			end

			v79(nil)
			v68(nil)
			v111(s7)
			v101(CHAT_CREATE_UNIVERSE_ERROR)
		end)
	end, {
		sessionId,
		v61,
		t5.onProjectResolved,
		v79,
		v111,
		v101,
		v54,
		v68,
		v114
	})
	local v116 = React.useCallback(function() -- line: 900
		-- upvalues: v102 (copy), v111 (copy), v95 (copy), v76 (copy), v62 (copy), sessionId (ref), v75 (copy), v103 (copy), v105 (copy), t5 (copy), universeId (ref), v77 (copy), v70 (copy), v115 (copy), v90 (copy), v114 (copy)
		local current5 = v102.current
		local v175 = string.gsub(current5, "^%s*(.-)%s*$", "%1")

		if v175 == "" then
			v111("")

			return false
		end

		if v95 then
			local current6 = v76.current
			local v177 = v62
			local v178 = sessionId
			local v179 = if not (current6 ~= nil and (v177 == current6.session and (v178 == nil or (v178 == "" or (v178 == current6.sessionId or current6.sessionId == nil and v178 == current6.session.getCasSessionId()))))) then nil else v75.current

			if v179 ~= nil and v179.trySubmitComposerText(v175) then
				v111("")

				if v103.current then
					v103.current.releaseFocus()
				end

				v105.scrollToBottomAfterSend()

				return true
			end

			return false
		end

		local v180 = t5.createUniverseOnFirstPrompt == true and universeId == nil

		if not v180 and v62 == nil then
			return false
		end

		v105.captureStickToBottomForSend()

		local v181 = v77

		v181.current = v181.current + 1

		local current7 = v77.current

		v70(nil)
		v111("")

		if v103.current then
			v103.current.releaseFocus()
		end

		if v180 then
			v115(v175, current7, v90.latestSequenceId)
		else
			v114(v62, v175, current7, v90.latestSequenceId)
		end

		return true
	end, {
		v62,
		sessionId,
		universeId,
		v95,
		v105,
		v111,
		v115,
		v114,
		t5.createUniverseOnFirstPrompt,
		v70,
		v90
	})
	local v117 = React.useCallback(function() -- line: 957
		-- upvalues: v76 (copy), v62 (copy), sessionId (ref), v75 (copy), v77 (copy), v79 (copy), v78 (copy), v68 (copy), v70 (copy), v90 (copy), placeId (ref), v106 (copy)
		local current8 = v76.current
		local v184 = v62
		local v185 = sessionId
		local v186 = if not (current8 ~= nil and (v184 == current8.session and (v185 == nil or (v185 == "" or (v185 == current8.sessionId or current8.sessionId == nil and v185 == current8.session.getCasSessionId()))))) then nil else v75.current

		if v186 == nil then
			return
		end

		local v187 = v77

		v187.current = v187.current + 1
		v186.stop()
		v79(nil)
		v78.current = nil
		v68(nil)
		v70({
			session = v62,
			sessionId = v62.getCasSessionId(),
			startSequenceId = v90.activeTurnStartSequenceId
		})

		if placeId ~= nil then
			v106(placeId, "Idle")
		end
	end, {
		v62,
		sessionId,
		placeId,
		v106,
		v79,
		v68,
		v70,
		v90
	})
	local v118 = t5.autoFocusComposer == nil or t5.autoFocusComposer
	local v119 = if t5.focusComposerWhen ~= nil then t5.focusComposerWhen else v118

	React.useEffect(function() -- line: 992
		-- upvalues: v118 (copy), v119 (copy), v103 (copy)
		if not v118 or not v119 then
			return function() -- line: 994
			end
		end

		local u188 = false
		local v189 = v103

		local function v190() -- line: 997
			-- upvalues: u188 (ref)
			return u188
		end

		local n10 = 8

		local function tryFocus() -- line: 167
			-- upvalues: v190 (copy), v189 (copy), n10 (ref), tryFocus (copy)
			if v190() then
				return
			end

			local current9 = v189.current

			if current9 then
				current9.focus()

				return
			end

			n10 -= 1

			if n10 > 0 then
				task.delay(0, tryFocus)
			end
		end

		task.defer(tryFocus)

		return function() -- line: 1000
			-- upvalues: u188 (ref)
			u188 = true
		end
	end, {
		v118,
		v119
	})

	local v120 = React.useCallback(function(s8: string) -- line: 1005
		-- upvalues: placeId (ref), launchPlaytestWithLoadingState (copy)
		if placeId == nil then
			return
		end

		launchPlaytestWithLoadingState(placeId, s8, true)
	end, { placeId })

	return {
		messages = messages,
		localToolActions = v87,
		composerText = v98,
		composerErrorText = v100,
		setComposerText = v111,
		isAssistantResponding = v95,
		canStopAssistantResponse = v82 ~= nil,
		canSendWhileResponding = v96,
		sendMessage = v116,
		stopAssistantResponse = v117,
		setScrollingFrame = v105.setScrollingFrame,
		textBoxRef = v103,
		clockBinding = v104,
		playtestPlaceId = placeId,
		launchPlaytest = if placeId == nil then nil else v120,
		hasPublishedTurn = includesPublishTool,
		subagentTaskState = subagentTaskState
	}
end

return useChatSessionCore
