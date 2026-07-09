local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local MessageBusService = game:GetService("MessageBusService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)
local React = require(BuildExperienceParent.React)
local ReactUtils = require(BuildExperienceParent.ReactUtils)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)

require(script.Parent.chatTypes)

local creatorAgentChat = require(script.Parent.creatorAgentChat)
local parseSessionStream = require(script.Parent.parseSessionStream)
local useChatScroll = require(script.Parent.useChatScroll)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)

require(BuildExperience.Stores.GetPlaytestLoadingStore.createPlaytestLoadingStore)

local getCurrentExperienceProject = require(BuildExperience.utils.getCurrentExperienceProject)
local launchPlaytestWithLoadingState = require(BuildExperience.utils.launchPlaytestWithLoadingState)
local MessageId = MessageBusService:GetMessageId("Game", "onGameLeave")
local t1 = {
	submittedToolCallIds = {},
	askUserByToolCallId = {},
	planByToolCallId = {}
}
local t2 = {
	onAnswerSelectedByToolCallId = {},
	onPlanAcceptedByToolCallId = {}
}
local v20 = Signals.createSignal(t1)
local v21 = Signals.createSignal(t2)
local v22 = Signals.createSignal(nil)

local function trimMessage(s1: string) -- line: 91
	return string.gsub(s1, "^%s*(.-)%s*$", "%1")
end
local function refreshVersionHistoryAfterPublish(n1: number?) -- line: 95
	-- upvalues: PlaceVersionHistory (copy)
	if n1 == nil then
		return
	end

	PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(n1)
end
local function scheduleComposerAutoFocus(t3: {[any]: any}, p1: ((...any) -> ...any)) -- line: 102
	local n2 = 8

	local function tryFocus() -- line: 104
		-- upvalues: p1 (copy), t3 (copy), n2 (ref), tryFocus (copy)
		if p1() then
			return
		end

		local current = t3.current

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
local function getIsAgentLoadingForPlaceId(p2, n3: number?) -- line: 121
	-- upvalues: GetPlaytestLoadingStore (copy)
	if n3 == nil then
		return false
	end

	return GetPlaytestLoadingStore(p2).getAgentStatusForPlaceId(n3)(p2) == "Loading"
end
local function getResumeSessionKey(p3) -- line: 128
	local v38 = p3.getCasSessionId()

	if typeof(v38) == "string" and v38 ~= "" then
		return v38
	end

	local universeId = p3.universeId
	local placeId = p3.placeId

	if universeId ~= nil and placeId ~= nil then
		return `{ universeId }:{ placeId }`
	end

	return nil
end
local function useChatSessionCore(t4: {[any]: any}) -- line: 141
	-- upvalues: getCurrentExperienceProject (copy), CreatorAgentChat (copy), React (copy), SignalsReact (copy), v20 (copy), v21 (copy), v22 (copy), parseSessionStream (copy), PlaceVersionHistory (copy), ReactUtils (copy), useChatScroll (copy), GetPlaytestLoadingStore (copy), Signals (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy), creatorAgentChat (copy), launchPlaytestWithLoadingState (copy)
	local v42 = t4.placeId or getCurrentExperienceProject().placeId
	local v43 = t4.universeId or getCurrentExperienceProject().universeId
	local sessionId = t4.sessionId
	local v45 = t4.hydrateHistoryWhen == nil or t4.hydrateHistoryWhen
	local v46 = CreatorAgentChat.getCreatorAgentChatStore()
	local v47 = React.useMemo(function() -- line: 148
		-- upvalues: v46 (copy), v43 (copy), v42 (copy), sessionId (copy)
		return v46.getSessionForProject(v43, v42, sessionId)
	end, {
		v43,
		v42,
		sessionId,
		v46
	})

	React.useLayoutEffect(function() -- line: 152
		-- upvalues: sessionId (copy), v47 (copy)
		if sessionId == nil or sessionId == "" then
			return
		end

		v47.setCasSessionId(sessionId)
	end, {
		v47,
		sessionId
	})

	local v48 = SignalsReact.useSignalState(v47.getMergedHistory)
	local v49, v50 = React.useState(nil)
	local v51, v52 = React.useState(nil)

	React.useEffect(function() -- line: 176
		-- upvalues: v52 (copy)
		v52(nil)
	end, { v47 })

	local v53, v54 = React.useState(nil)
	local v55 = React.useRef(nil)
	local v56 = React.useRef(0)
	local v57 = React.useRef(nil)
	local v58 = React.useCallback(function(p4) -- line: 186
		-- upvalues: v55 (copy), v54 (copy)
		v55.current = p4
		v54(p4)
	end, { v54 })
	local v59 = if v53 == nil then v20 else v53.getOptimisticLocalTools
	local v60 = if v53 == nil then v21 else v53.getLocalToolActions
	local v61 = if v53 == nil then v22 else v53.getSetupErrorText
	local v62 = SignalsReact.useSignalState(v59)
	local v63 = SignalsReact.useSignalState(v60)
	local v64 = SignalsReact.useSignalState(v61)
	local v65 = React.useMemo(function() -- line: 207
		-- upvalues: v53 (copy), v64 (copy)
		if v53 == nil then
			return nil
		end

		return {
			setupErrorText = v64
		}
	end, {
		v53,
		v64
	})
	local v66 = React.useMemo(function() -- line: 215
		-- upvalues: parseSessionStream (copy), v48 (copy), v47 (copy), sessionId (copy), v62 (copy), v49 (copy), v65 (copy), v51 (copy)
		return parseSessionStream(v48, {
			sessionId = v47.getCasSessionId() or sessionId,
			universeId = v47.universeId,
			placeId = v47.placeId,
			optimisticLocalTools = v62,
			pendingUserMessage = if v49 == nil then nil else v49.text,
			pendingUserMessageAfterSequenceId = if v49 == nil then nil else v49.afterSequenceId,
			liveAssistantMessage = v65,
			optimisticCancelledStartSequenceId = if v51 == nil then nil else v51.startSequenceId
		})
	end, {
		v48,
		v47,
		sessionId,
		v62,
		v49,
		v65,
		v51
	})
	local messages = v66.messages
	local subagentTaskState = v66.subagentTaskState
	local includesPublishTool = v66.includesPublishTool
	local activeTurnState = v66.activeTurnState

	React.useEffect(function() -- line: 252
		-- upvalues: v53 (copy), activeTurnState (copy)
		if v53 == nil or activeTurnState == nil then
			return
		end

		v53.syncFromTurnState(activeTurnState)
	end, {
		v53,
		activeTurnState
	})
	React.useEffect(function() -- line: 259
		-- upvalues: v66 (copy), v42 (copy), PlaceVersionHistory (copy)
		if not v66.includesPublishTool then
			return
		end

		local v98 = v42

		if v98 == nil then
			return
		end

		PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(v98)
	end, {
		v66.includesPublishTool,
		v42
	})

	local v71, v72 = React.useBinding("")
	local v73, v74 = React.useState(nil)
	local v75 = React.useRef("")
	local v76 = React.useRef(nil)
	local v77 = ReactUtils.useClock()
	local v78 = useChatScroll()
	local v79 = React.useCallback(function(p5) -- line: 274
		-- upvalues: v42 (copy), GetPlaytestLoadingStore (copy)
		if v42 == nil then
			return
		end

		GetPlaytestLoadingStore().setAgentStatusForPlaceId(v42, p5)
	end, { v42 })
	local v80 = React.useMemo(function() -- line: 281
		-- upvalues: Signals (copy)
		return (Signals.createSignal(false))
	end, {})
	local v81 = React.useCallback(function(p6) -- line: 285
		-- upvalues: v42 (copy), v80 (copy), GetPlaytestLoadingStore (copy)
		if v42 == nil then
			return v80(p6)
		end

		local v101 = v42

		if v101 == nil then
			return false
		end

		return GetPlaytestLoadingStore(p6).getAgentStatusForPlaceId(v101)(p6) == "Loading"
	end, {
		v42,
		v80
	})
	local v82 = SignalsReact.useSignalState(v81)
	local v83 = React.useCallback(function(p7: ((...any) -> ...any)?) -- line: 293
		-- upvalues: v78 (copy), v47 (copy)
		local function v103() -- line: 294
			-- upvalues: p7 (copy)
			if p7 ~= nil then
				return p7()
			end

			return false
		end

		v78.captureDistanceFromBottom()
		task.spawn(function() -- line: 301
			-- upvalues: v47 (copy), v103 (copy), v78 (copy), p7 (copy)
			if v47.loadOlderHistory(v103) and (v47.getNextHistoryPageToken() ~= nil and v78.isAtTopRef.current) then
				task.delay(0.1, function() -- line: 304
					-- upvalues: p7 (copy), v78 (copy), v47 (copy), v103 (copy)
					if p7 ~= nil and p7() then
						return
					end

					if v78.isViewportUnderfilled() then
						v47.loadOlderHistory(v103)
					end
				end)
			end
		end)
	end, {
		v47,
		v78
	})
	local v84 = React.useCallback(function(p8: ((...any) -> ...any)) -- line: 316
		-- upvalues: v47 (copy), v78 (copy), v83 (copy)
		task.delay(0.1, function() -- line: 317
			-- upvalues: p8 (copy), v47 (copy), v78 (copy), v83 (copy)
			if p8() then
				return
			end

			if v47.getNextHistoryPageToken() == nil then
				return
			end

			if not v78.isViewportUnderfilled() then
				return
			end

			v83(p8)
		end)
	end, {
		v83,
		v78,
		v47
	})
	local v85 = React.useCallback(function(p9: ((...any) -> ...any)) -- line: 332
		-- upvalues: v47 (copy), v84 (copy)
		if v47.getNextHistoryPageToken() == nil then
			return
		end

		v84(p9)
	end, {
		v84,
		v47
	})
	local v86 = React.useRef(v85)

	v86.current = v85
	React.useEffect(function() -- line: 341
		-- upvalues: v78 (copy), v83 (copy)
		v78.setOnScrolledToTop(function() -- line: 342
			-- upvalues: v83 (copy)
			v83(nil)
		end)

		return function() -- line: 345
			-- upvalues: v78 (copy)
			v78.setOnScrolledToTop(nil)
		end
	end, {
		v78.setOnScrolledToTop,
		v83
	})
	React.useEffect(function() -- line: 350
		-- upvalues: v45 (copy), sessionId (copy), v47 (copy), v86 (copy), v43 (copy), v46 (copy)
		if not v45 then
			return
		end

		local u106 = false
		local u107 = sessionId

		local function isHydrateCancelled() -- line: 357
			-- upvalues: u106 (ref), u107 (ref), v47 (copy)
			if u106 then
				return true
			end

			if u107 ~= nil and u107 ~= "" then
				return v47.getCasSessionId() ~= u107
			end

			return false
		end
		local function continueAfterSessionReady() -- line: 366
			-- upvalues: u106 (ref), u107 (ref), v47 (copy), v86 (copy), isHydrateCancelled (copy)
			if not not u106 or u107 ~= nil and (u107 ~= "" and v47.getCasSessionId() ~= u107) then
				return
			end

			v86.current(isHydrateCancelled)
		end
		local function hydrateKnownSession(s2: string) -- line: 373
			-- upvalues: v47 (copy), u106 (ref), u107 (ref), v86 (copy), isHydrateCancelled (copy)
			v47.setCasSessionId(s2)

			if v47.hasLoadedHistory() and #v47.getMergedHistory(false) > 0 then
				if not not u106 or u107 ~= nil and (u107 ~= "" and v47.getCasSessionId() ~= u107) then
					return
				end

				v86.current(isHydrateCancelled)

				return
			end

			if v47.refreshSession(isHydrateCancelled) and (not u106 and (u107 == nil or (u107 == "" or v47.getCasSessionId() == u107))) then
				if not not u106 or u107 ~= nil and (u107 ~= "" and v47.getCasSessionId() ~= u107) then
					return
				end

				v86.current(isHydrateCancelled)
			end
		end

		task.spawn(function() -- line: 384
			-- upvalues: sessionId (copy), hydrateKnownSession (copy), v43 (copy), v47 (copy), v46 (copy), u106 (ref), u107 (ref)
			if sessionId ~= nil and sessionId ~= "" then
				hydrateKnownSession(sessionId)

				return
			end

			if v43 == nil or v43 == 0 or v47.hasLoadedHistory() and #v47.getMergedHistory(false) > 0 then
				return
			end

			local v147 = v46.sessionFindByUniverse({
				sort = "desc",
				universeId = v43
			})

			while v147.state(false).status == "pending" and (not u106 and (u107 == nil or (u107 == "" or v47.getCasSessionId() == u107))) do
				task.wait()
			end

			if u106 or u107 ~= nil and (u107 ~= "" and v47.getCasSessionId() ~= u107) or v147.state(false).status ~= "succeeded" then
				return
			end

			local result = v147.state(false).result
			local v149 = if result == nil then nil else result.sessions
			local v150 = if typeof(v149) ~= "table" then nil else v149[1]
			local v151 = if typeof(v150) ~= "table" then nil else v150.sessionId

			if typeof(v151) ~= "string" or v151 == "" then
				v47.markHistoryLoaded()

				return
			end

			u107 = v151
			hydrateKnownSession(v151)
		end)

		return function() -- line: 422
			-- upvalues: u106 (ref)
			u106 = true
		end
	end, {
		v47,
		sessionId,
		v43,
		v46,
		v45
	})
	React.useEffect(function() -- line: 427
		-- upvalues: v47 (copy), sessionId (copy), v86 (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy)
		local u111 = false

		local function refreshKnownSession() -- line: 429
			-- upvalues: v47 (copy), sessionId (copy), u111 (ref), v86 (copy)
			local v152 = v47.getCasSessionId()

			if (v152 == nil or v152 == "") and (sessionId ~= nil and sessionId ~= "") then
				v152 = sessionId
			end

			if v152 == nil or v152 == "" then
				return
			end

			task.spawn(function() -- line: 437
				-- upvalues: v47 (copy), u111 (ref), v86 (copy)
				if v47.refreshSession(function() -- line: 438
					-- upvalues: u111 (ref)
					return u111
				end) and not u111 then
					v86.current(function() -- line: 441
						-- upvalues: u111 (ref)
						return u111
					end)
				end
			end)
		end

		local v113 = MessageBusService:Subscribe(MessageId, function(_) -- line: 448
			-- upvalues: refreshKnownSession (copy)
			refreshKnownSession()
		end, false, true)
		local connection = AppLifecycleObserverService.OnUnhide:Connect(refreshKnownSession)

		return function() -- line: 453
			-- upvalues: u111 (ref), v113 (copy), connection (copy)
			u111 = true
			v113:Disconnect()
			connection:Disconnect()
		end
	end, {
		v47,
		sessionId
	})

	local v87 = React.useCallback(function(s3: string) -- line: 460
		-- upvalues: v75 (copy), v72 (copy), v74 (copy)
		v75.current = s3
		v72(s3)
		v74(nil)
	end, {
		v72,
		v74
	})
	local v88 = React.useCallback(function(n4: number, s4: string?, s5: string?) -- line: 467
		-- upvalues: v56 (copy), v58 (copy), v57 (copy), v50 (copy), v79 (copy), v87 (copy), v74 (copy), v47 (copy), v78 (copy)
		if n4 ~= v56.current then
			return
		end

		v58(nil)
		v57.current = nil
		v50(nil)

		if s4 == "content_policy" then
			v79("Idle")

			if s5 ~= nil then
				v87(s5)
				v74("Your message violates Roblox safety policy. Edit it and try again.")
			end

			task.spawn(function() -- line: 481
				-- upvalues: v47 (copy), v56 (copy), n4 (copy)
				v47.refreshSession(function() -- line: 482
					-- upvalues: v56 (copy), n4 (copy)
					return v56.current ~= n4
				end)
			end)

			return
		end

		v79("Completed")
		v78.scrollToBottomAfterSend()

		local v119 = v47.getCasSessionId()

		if v119 ~= nil and v119 ~= "" then
			task.spawn(function() -- line: 496
				-- upvalues: v47 (copy), v56 (copy), n4 (copy)
				v47.refreshSession(function() -- line: 497
					-- upvalues: v56 (copy), n4 (copy)
					return v56.current ~= n4
				end)
			end)
		end
	end, {
		v47,
		v79,
		v78,
		v87,
		v74,
		v58,
		v50
	})
	local v89 = React.useRef(v45)

	React.useEffect(function() -- line: 516
		-- upvalues: v45 (copy), v89 (copy), v82 (copy), v53 (copy), v78 (copy)
		local v120 = v45 and not v89.current

		v89.current = v45

		if not v45 then
			return
		end

		if not v120 and not v82 and v53 == nil then
			return
		end

		v78.scrollToBottomUnconditionally()
		task.defer(v78.scrollToBottomUnconditionally)
		task.delay(0.15, v78.scrollToBottomUnconditionally)
	end, {
		v45,
		v82,
		v53,
		#messages,
		v78
	})
	React.useEffect(function() -- line: 542
		-- upvalues: v55 (copy), v51 (copy), v47 (copy), v56 (copy), v57 (copy), v79 (copy), creatorAgentChat (copy), v88 (copy), v58 (copy), v78 (copy), v66 (copy), v53 (copy), v46 (copy), v82 (copy)
		if v55.current ~= nil then
			return
		end

		if v51 ~= nil then
			return
		end

		local v121 = v47
		local v122 = v121.getCasSessionId()

		if typeof(v122) == "string" and v122 ~= "" then
		else
			local universeId = v121.universeId
			local placeId = v121.placeId

			v122 = if universeId == nil or placeId == nil then nil else `{ universeId }:{ placeId }`
		end

		if v122 == nil then
			return
		end

		local function attachResumedTurn(p11, n5: number?) -- line: 558
			-- upvalues: v56 (copy), v57 (copy), v79 (copy), creatorAgentChat (copy), v47 (copy), v88 (copy), v58 (copy), v78 (copy)
			local v156 = v56

			v156.current = v156.current + 1

			local current = v56.current

			v57.current = n5
			v79("Loading")

			local v158 = creatorAgentChat.createResumedAssistantTurn(v47, p11, function(p12) -- line: 566
				-- upvalues: v88 (copy), current (copy)
				v88(current, p12, nil)
			end, if n5 == nil then nil else n5 - 1)

			v58(v158)
			v158.start()
			v78.scrollToBottomUnconditionally()
		end

		if v66.activeTurnState ~= nil and v66.activeTurnItemIndex ~= nil and not v66.activeTurnState.isDone then
			local activeTurnStartSequenceId = v66.activeTurnStartSequenceId

			if activeTurnStartSequenceId == v57.current and v53 ~= nil then
				return
			end

			local v127 = v46.resumeTurnFromHistory(v122, v66.activeTurnState, v66.activeTurnSequenceIds)

			if v127 ~= nil then
				attachResumedTurn(v127, activeTurnStartSequenceId)
			end

			return
		end

		v57.current = nil

		local v128 = v46.getActiveTurnHandle(v122)
		local v129 = if v128 == nil then nil else v128.state(false)
		local v130 = v128 ~= nil and (v129 ~= nil and not v129.isDone)

		if not v82 and not v130 then
			return
		end

		if v130 then
			attachResumedTurn(v128, nil)
		end
	end, {
		v66,
		v47,
		v46,
		v82,
		v53,
		v79,
		v88,
		v78,
		v58,
		v51
	})

	local v90 = React.useCallback(function() -- line: 626
		-- upvalues: v75 (copy), v87 (copy), v82 (copy), v55 (copy), v76 (copy), v78 (copy), v56 (copy), v79 (copy), v52 (copy), v50 (copy), v66 (copy), creatorAgentChat (copy), v47 (copy), v88 (copy), v58 (copy)
		local current = v75.current
		local v132 = string.gsub(current, "^%s*(.-)%s*$", "%1")

		if v132 == "" then
			v87("")

			return false
		end

		if v82 then
			local current2 = v55.current

			if current2 ~= nil and current2.trySubmitComposerText(v132) then
				v87("")

				if v76.current then
					v76.current.releaseFocus()
				end

				v78.scrollToBottomAfterSend()

				return true
			end

			return false
		end

		v78.captureStickToBottomForSend()

		local v134 = v56

		v134.current = v134.current + 1

		local current3 = v56.current

		v79("Loading")
		v52(nil)
		v50({
			text = v132,
			afterSequenceId = v66.latestSequenceId
		})

		local v136 = creatorAgentChat.createLiveAssistantTurn(v47, v132, function(s6: string?) -- line: 653
			-- upvalues: v88 (copy), current3 (copy), v132 (copy)
			v88(current3, s6, v132)
		end)

		v58(v136)
		v87("")

		if v76.current then
			v76.current.releaseFocus()
		end

		v78.scrollToBottomAfterSend()
		v136.start()

		return true
	end, {
		v47,
		v82,
		v79,
		v78,
		v87,
		v88,
		v58,
		v50,
		v52,
		v66
	})
	local v91 = React.useCallback(function() -- line: 681
		-- upvalues: v56 (copy), v55 (copy), v58 (copy), v57 (copy), v50 (copy), v52 (copy), v66 (copy), v79 (copy)
		local v137 = v56

		v137.current = v137.current + 1

		local current = v55.current

		if current ~= nil then
			current.stop()
		end

		v58(nil)
		v57.current = nil
		v50(nil)
		v52({
			startSequenceId = v66.activeTurnStartSequenceId
		})
		v79("Idle")
	end, {
		v79,
		v58,
		v50,
		v52,
		v66
	})
	local v92 = t4.autoFocusComposer == nil or t4.autoFocusComposer
	local v93 = if t4.focusComposerWhen ~= nil then t4.focusComposerWhen else v92

	React.useEffect(function() -- line: 704
		-- upvalues: v92 (copy), v93 (copy), v76 (copy)
		if not v92 or not v93 then
			return function() -- line: 706
			end
		end

		local u139 = false
		local v140 = v76

		local function v141() -- line: 709
			-- upvalues: u139 (ref)
			return u139
		end

		local n6 = 8

		local function tryFocus() -- line: 104
			-- upvalues: v141 (copy), v140 (copy), n6 (ref), tryFocus (copy)
			if v141() then
				return
			end

			local current = v140.current

			if current then
				current.focus()

				return
			end

			n6 -= 1

			if n6 > 0 then
				task.delay(0, tryFocus)
			end
		end

		task.defer(tryFocus)

		return function() -- line: 712
			-- upvalues: u139 (ref)
			u139 = true
		end
	end, {
		v92,
		v93
	})

	local v94 = React.useCallback(function(s7: string) -- line: 717
		-- upvalues: t4 (copy), getCurrentExperienceProject (copy), launchPlaytestWithLoadingState (copy)
		local v145 = t4.placeId or getCurrentExperienceProject().placeId

		if v145 == nil then
			return
		end

		launchPlaytestWithLoadingState(v145, s7, true)
	end, { t4.placeId })
	local v95 = t4.placeId or getCurrentExperienceProject().placeId

	return {
		messages = messages,
		localToolActions = v63,
		composerText = v71,
		composerErrorText = v73,
		setComposerText = v87,
		isAssistantResponding = v82,
		sendMessage = v90,
		stopAssistantResponse = v91,
		setScrollingFrame = v78.setScrollingFrame,
		textBoxRef = v76,
		clockBinding = v77,
		playtestPlaceId = v95,
		launchPlaytest = if v95 == nil then nil else v94,
		hasPublishedTurn = includesPublishTool,
		subagentTaskState = subagentTaskState
	}
end

return useChatSessionCore
