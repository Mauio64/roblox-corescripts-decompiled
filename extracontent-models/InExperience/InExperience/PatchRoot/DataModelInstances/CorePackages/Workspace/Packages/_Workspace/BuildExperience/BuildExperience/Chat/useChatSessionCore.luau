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
local v28 = Signals.createSignal({})

local function getIsAssistantRespondingForPlaceId(p1, n1: number?) -- line: 109
	-- upvalues: GetPlaytestLoadingStore (copy)
	local v37 = GetPlaytestLoadingStore(p1)

	if n1 == nil then
		return false
	end

	return v37.getAgentStatusForPlaceId(n1)(p1) == "Loading"
end
local function trimMessage(s1: string) -- line: 117
	return string.gsub(s1, "^%s*(.-)%s*$", "%1")
end
local function refreshVersionHistoryAfterPublish(n2: number?) -- line: 121
	-- upvalues: PlaceVersionHistory (copy)
	if n2 == nil then
		return
	end

	PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(n2)
end
local function scheduleComposerAutoFocus(t3: {[any]: any}, p2: ((...any) -> ...any)) -- line: 128
	local n3 = 8

	local function tryFocus() -- line: 130
		-- upvalues: p2 (copy), t3 (copy), n3 (ref), tryFocus (copy)
		if p2() then
			return
		end

		local current = t3.current

		if current then
			current.focus()

			return
		end

		n3 -= 1

		if n3 > 0 then
			task.delay(0, tryFocus)
		end
	end

	task.defer(tryFocus)
end
local function getResumeSessionKey(p3) -- line: 147
	local v45 = p3.getCasSessionId()

	if typeof(v45) == "string" and v45 ~= "" then
		return v45
	end

	local universeId = p3.universeId
	local placeId = p3.placeId

	if universeId ~= nil and placeId ~= nil then
		return `{ universeId }:{ placeId }`
	end

	return nil
end
local function useChatSessionCore(t4: {[any]: any}) -- line: 160
	-- upvalues: React (copy), CreatorAgentChat (copy), v28 (copy), SignalsReact (copy), v25 (copy), v26 (copy), v27 (copy), parseSessionStream (copy), PlaceVersionHistory (copy), ReactUtils (copy), useChatScroll (copy), GetPlaytestLoadingStore (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy), creatorAgentChat (copy), UniverseCreate (copy), getDefaultTemplatePlaceId (copy), debug (copy), UniverseConfiguration (copy), CHAT_CREATE_UNIVERSE_ERROR (copy), launchPlaytestWithLoadingState (copy)
	local v49, v50 = React.useState(nil)
	local placeId = t4.placeId
	local universeId = t4.universeId
	local sessionId = t4.sessionId

	if v49 ~= nil then
		placeId = v49.placeId
		universeId = v49.universeId
		sessionId = v49.sessionId
	end

	local v54 = t4.hydrateHistoryWhen == nil or t4.hydrateHistoryWhen
	local v55 = CreatorAgentChat.getCreatorAgentChatStore()
	local v56 = React.useMemo(function() -- line: 173
		-- upvalues: universeId (ref), v55 (copy), placeId (ref), sessionId (ref)
		if universeId == nil then
			return nil
		end

		return v55.getSessionForProject(universeId, placeId, sessionId)
	end, {
		universeId,
		placeId,
		sessionId,
		v55
	})

	React.useLayoutEffect(function() -- line: 180
		-- upvalues: v56 (copy), sessionId (ref)
		if v56 == nil or (sessionId == nil or sessionId == "") then
			return
		end

		v56.setCasSessionId(sessionId)
	end, {
		v56,
		sessionId
	})

	local v57 = if v56 == nil then v28 else v56.getMergedHistory
	local v58 = SignalsReact.useSignalState(v57)
	local v59, v60 = React.useState(nil)
	local v61, v62 = React.useState(nil)

	React.useEffect(function() -- line: 205
		-- upvalues: v62 (copy)
		v62(nil)
	end, { v56 })

	local v63, v64 = React.useState(nil)
	local v65 = React.useRef(nil)
	local v66 = React.useRef(0)
	local v67 = React.useRef(nil)
	local v68 = React.useCallback(function(p4) -- line: 215
		-- upvalues: v65 (copy), v64 (copy)
		v65.current = p4
		v64(p4)
	end, { v64 })
	local v69 = if v63 == nil then v25 else v63.getOptimisticLocalTools
	local v70 = if v63 == nil then v26 else v63.getLocalToolActions
	local v71 = if v63 == nil then v27 else v63.getSetupErrorText
	local v72 = SignalsReact.useSignalState(v69)
	local v73 = SignalsReact.useSignalState(v70)
	local v74 = SignalsReact.useSignalState(v71)
	local v75 = React.useMemo(function() -- line: 236
		-- upvalues: v63 (copy), v74 (copy)
		if v63 == nil then
			return nil
		end

		return {
			setupErrorText = v74
		}
	end, {
		v63,
		v74
	})
	local v76 = React.useMemo(function() -- line: 244
		-- upvalues: parseSessionStream (copy), v58 (copy), v56 (copy), sessionId (ref), universeId (ref), placeId (ref), v72 (copy), v59 (copy), v75 (copy), v61 (copy)
		return parseSessionStream(v58, {
			sessionId = if v56 == nil then sessionId else v56.getCasSessionId() or sessionId,
			universeId = if v56 == nil then universeId else v56.universeId,
			placeId = if v56 == nil then placeId else v56.placeId,
			optimisticLocalTools = v72,
			pendingUserMessage = if v59 == nil then nil else v59.text,
			pendingUserMessageAfterSequenceId = if v59 == nil then nil else v59.afterSequenceId,
			liveAssistantMessage = v75,
			optimisticCancelledStartSequenceId = if v61 == nil then nil else v61.startSequenceId
		})
	end, {
		v58,
		v56,
		sessionId,
		universeId,
		placeId,
		v72,
		v59,
		v75,
		v61
	})
	local messages = v76.messages
	local subagentTaskState = v76.subagentTaskState
	local includesPublishTool = v76.includesPublishTool
	local activeTurnState = v76.activeTurnState

	React.useEffect(function() -- line: 283
		-- upvalues: v63 (copy), activeTurnState (copy)
		if v63 == nil or activeTurnState == nil then
			return
		end

		v63.syncFromTurnState(activeTurnState)
	end, {
		v63,
		activeTurnState
	})
	React.useEffect(function() -- line: 290
		-- upvalues: v76 (copy), placeId (ref), PlaceVersionHistory (copy)
		if not v76.includesPublishTool then
			return
		end

		local v108 = placeId

		if v108 == nil then
			return
		end

		PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(v108)
	end, {
		v76.includesPublishTool,
		placeId
	})

	local v81, v82 = React.useBinding("")
	local v83, v84 = React.useState(nil)
	local v85 = React.useRef("")
	local v86 = React.useRef(nil)
	local v87 = ReactUtils.useClock()
	local v88 = useChatScroll()
	local v89 = React.useCallback(function(p5) -- line: 305
		-- upvalues: placeId (ref), GetPlaytestLoadingStore (copy)
		local v110 = placeId
		local v111 = GetPlaytestLoadingStore(p5)

		if v110 == nil then
			return false
		end

		return v111.getAgentStatusForPlaceId(v110)(p5) == "Loading"
	end, { placeId })
	local v90 = SignalsReact.useSignalState(v89)
	local v91 = React.useCallback(function(n4: number, p6) -- line: 309
		-- upvalues: GetPlaytestLoadingStore (copy)
		GetPlaytestLoadingStore().setAgentStatusForPlaceId(n4, p6)
	end, {})
	local v92 = React.useCallback(function(p7: ((...any) -> ...any)?) -- line: 313
		-- upvalues: v88 (copy), v56 (copy)
		local function v115() -- line: 314
			-- upvalues: p7 (copy)
			if p7 ~= nil then
				return p7()
			end

			return false
		end

		v88.captureDistanceFromBottom()
		task.spawn(function() -- line: 321
			-- upvalues: v56 (copy), v115 (copy), v88 (copy), p7 (copy)
			if v56 == nil then
				return
			end

			if v56.loadOlderHistory(v115) and v56.getNextHistoryPageToken() ~= nil and v88.isAtTopRef.current then
				task.delay(0.1, function() -- line: 327
					-- upvalues: p7 (copy), v88 (copy), v56 (copy), v115 (copy)
					if p7 ~= nil and p7() then
						return
					end

					if v88.isViewportUnderfilled() then
						v56.loadOlderHistory(v115)
					end
				end)
			end
		end)
	end, {
		v56,
		v88
	})
	local v93 = React.useCallback(function(p8: ((...any) -> ...any)) -- line: 339
		-- upvalues: v56 (copy), v88 (copy), v92 (copy)
		task.delay(0.1, function() -- line: 340
			-- upvalues: p8 (copy), v56 (copy), v88 (copy), v92 (copy)
			if p8() then
				return
			end

			if v56 == nil then
				return
			end

			if v56.getNextHistoryPageToken() == nil then
				return
			end

			if not v88.isViewportUnderfilled() then
				return
			end

			v92(p8)
		end)
	end, {
		v92,
		v88,
		v56
	})
	local v94 = React.useCallback(function(p9: ((...any) -> ...any)) -- line: 358
		-- upvalues: v56 (copy), v93 (copy)
		if v56 == nil then
			return
		end

		if v56.getNextHistoryPageToken() == nil then
			return
		end

		v93(p9)
	end, {
		v93,
		v56
	})
	local v95 = React.useRef(v94)

	v95.current = v94
	React.useEffect(function() -- line: 370
		-- upvalues: v88 (copy), v92 (copy)
		v88.setOnScrolledToTop(function() -- line: 371
			-- upvalues: v92 (copy)
			v92(nil)
		end)

		return function() -- line: 374
			-- upvalues: v88 (copy)
			v88.setOnScrolledToTop(nil)
		end
	end, {
		v88.setOnScrolledToTop,
		v92
	})
	React.useEffect(function() -- line: 379
		-- upvalues: v54 (copy), v56 (copy), sessionId (ref), v95 (copy), universeId (ref), v55 (copy)
		if not v54 or v56 == nil then
			return
		end

		local u118 = false
		local u119 = sessionId

		local function isHydrateCancelled() -- line: 386
			-- upvalues: u118 (ref), u119 (ref), v56 (copy)
			if u118 then
				return true
			end

			if u119 ~= nil and u119 ~= "" then
				return v56.getCasSessionId() ~= u119
			end

			return false
		end
		local function continueAfterSessionReady() -- line: 395
			-- upvalues: u118 (ref), u119 (ref), v56 (copy), v95 (copy), isHydrateCancelled (copy)
			if not not u118 or u119 ~= nil and (u119 ~= "" and v56.getCasSessionId() ~= u119) then
				return
			end

			v95.current(isHydrateCancelled)
		end
		local function hydrateKnownSession(s2: string) -- line: 402
			-- upvalues: v56 (copy), u118 (ref), u119 (ref), v95 (copy), isHydrateCancelled (copy)
			v56.setCasSessionId(s2)

			if v56.hasLoadedHistory() and #v56.getMergedHistory(false) > 0 then
				if not not u118 or u119 ~= nil and (u119 ~= "" and v56.getCasSessionId() ~= u119) then
					return
				end

				v95.current(isHydrateCancelled)

				return
			end

			if v56.refreshSession(isHydrateCancelled) and (not u118 and (u119 == nil or (u119 == "" or v56.getCasSessionId() == u119))) then
				if not not u118 or u119 ~= nil and (u119 ~= "" and v56.getCasSessionId() ~= u119) then
					return
				end

				v95.current(isHydrateCancelled)
			end
		end

		task.spawn(function() -- line: 413
			-- upvalues: sessionId (ref), hydrateKnownSession (copy), universeId (ref), v56 (copy), v55 (copy), u118 (ref), u119 (ref)
			if sessionId ~= nil and sessionId ~= "" then
				hydrateKnownSession(sessionId)

				return
			end

			if universeId == nil or universeId == 0 or v56.hasLoadedHistory() and #v56.getMergedHistory(false) > 0 then
				return
			end

			local v169 = v55.sessionFindByUniverse({
				sort = "desc",
				universeId = universeId
			})

			while v169.state(false).status == "pending" and (not u118 and (u119 == nil or (u119 == "" or v56.getCasSessionId() == u119))) do
				task.wait()
			end

			if u118 or u119 ~= nil and (u119 ~= "" and v56.getCasSessionId() ~= u119) or v169.state(false).status ~= "succeeded" then
				return
			end

			local result = v169.state(false).result
			local v171 = if result == nil then nil else result.sessions
			local v172 = if typeof(v171) ~= "table" then nil else v171[1]
			local v173 = if typeof(v172) ~= "table" then nil else v172.sessionId

			if typeof(v173) ~= "string" or v173 == "" then
				v56.markHistoryLoaded()

				return
			end

			u119 = v173
			hydrateKnownSession(v173)
		end)

		return function() -- line: 451
			-- upvalues: u118 (ref)
			u118 = true
		end
	end, {
		v56,
		sessionId,
		universeId,
		v55,
		v54
	})
	React.useEffect(function() -- line: 456
		-- upvalues: v56 (copy), sessionId (ref), v95 (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy)
		if v56 == nil then
			return
		end

		local u123 = false

		local function refreshKnownSession() -- line: 461
			-- upvalues: v56 (copy), sessionId (ref), u123 (ref), v95 (copy)
			local v174 = v56.getCasSessionId()

			if (v174 == nil or v174 == "") and (sessionId ~= nil and sessionId ~= "") then
				v174 = sessionId
			end

			if v174 == nil or v174 == "" then
				return
			end

			task.spawn(function() -- line: 469
				-- upvalues: v56 (copy), u123 (ref), v95 (copy)
				if v56.refreshSession(function() -- line: 470
					-- upvalues: u123 (ref)
					return u123
				end) and not u123 then
					v95.current(function() -- line: 473
						-- upvalues: u123 (ref)
						return u123
					end)
				end
			end)
		end

		local v125 = MessageBusService:Subscribe(MessageId, function(_) -- line: 480
			-- upvalues: refreshKnownSession (copy)
			refreshKnownSession()
		end, false, true)
		local connection = AppLifecycleObserverService.OnUnhide:Connect(refreshKnownSession)

		return function() -- line: 485
			-- upvalues: u123 (ref), v125 (copy), connection (copy)
			u123 = true
			v125:Disconnect()
			connection:Disconnect()
		end
	end, {
		v56,
		sessionId
	})

	local v96 = React.useCallback(function(s3: string) -- line: 492
		-- upvalues: v85 (copy), v82 (copy), v84 (copy)
		v85.current = s3
		v82(s3)
		v84(nil)
	end, {
		v82,
		v84
	})
	local v97 = React.useCallback(function(n5: number, p11, s4: string?, p12) -- line: 499
		-- upvalues: v66 (copy), v68 (copy), v67 (copy), v60 (copy), v91 (copy), v96 (copy), v84 (copy), creatorAgentChat (copy), v88 (copy), t4 (copy), sessionId (ref), v50 (copy)
		if n5 ~= v66.current then
			return
		end

		v68(nil)
		v67.current = nil
		v60(nil)

		if p11 ~= nil then
			if p12.placeId ~= nil then
				v91(p12.placeId, "Idle")
			end

			if s4 ~= nil then
				v96(s4)
				v84(creatorAgentChat.getPromptFailureComposerError(p11))
			end

			task.spawn(function() -- line: 523
				-- upvalues: p12 (copy), v66 (copy), n5 (copy)
				p12.refreshSession(function() -- line: 524
					-- upvalues: v66 (copy), n5 (copy)
					return v66.current ~= n5
				end)
			end)

			return
		end

		if p12.placeId ~= nil then
			v91(p12.placeId, "Completed")
		end

		v88.scrollToBottomAfterSend()

		local v132 = p12.getCasSessionId()

		if v132 ~= nil and v132 ~= "" then
			if t4.createUniverseOnFirstPrompt and sessionId == nil and p12.universeId ~= nil then
				local t5 = {
					universeId = p12.universeId,
					placeId = p12.placeId,
					sessionId = v132
				}

				v50(t5)

				if t4.onProjectResolved ~= nil then
					t4.onProjectResolved(t5)
				end
			end

			task.spawn(function() -- line: 552
				-- upvalues: p12 (copy), v66 (copy), n5 (copy)
				p12.refreshSession(function() -- line: 553
					-- upvalues: v66 (copy), n5 (copy)
					return v66.current ~= n5
				end)
			end)
		end
	end, {
		t4.createUniverseOnFirstPrompt,
		t4.onProjectResolved,
		sessionId,
		v91,
		v50,
		v88,
		v96,
		v84,
		v68,
		v60
	})
	local v98 = React.useRef(v54)

	React.useEffect(function() -- line: 575
		-- upvalues: v54 (copy), v98 (copy), v90 (copy), v63 (copy), v88 (copy)
		local v134 = v54 and not v98.current

		v98.current = v54

		if not v54 then
			return
		end

		if not v134 and not v90 and v63 == nil then
			return
		end

		v88.scrollToBottomUnconditionally()
		task.defer(v88.scrollToBottomUnconditionally)
		task.delay(0.15, v88.scrollToBottomUnconditionally)
	end, {
		v54,
		v90,
		v63,
		#messages,
		v88
	})
	React.useEffect(function() -- line: 601
		-- upvalues: v65 (copy), v61 (copy), v56 (copy), v66 (copy), v67 (copy), placeId (ref), v91 (copy), creatorAgentChat (copy), v97 (copy), v68 (copy), v88 (copy), v76 (copy), v63 (copy), v55 (copy), v90 (copy)
		if v65.current ~= nil then
			return
		end

		if v61 ~= nil then
			return
		end

		if v56 == nil then
			return
		end

		local v135 = v56
		local v136 = v135.getCasSessionId()

		if typeof(v136) == "string" and v136 ~= "" then
		else
			local universeId2 = v135.universeId
			local placeId2 = v135.placeId

			v136 = if universeId2 == nil or placeId2 == nil then nil else `{ universeId2 }:{ placeId2 }`
		end

		if v136 == nil then
			return
		end

		local function attachResumedTurn(p13, n6: number?) -- line: 620
			-- upvalues: v66 (copy), v67 (copy), placeId (ref), v91 (copy), creatorAgentChat (copy), v56 (copy), v97 (copy), v68 (copy), v88 (copy)
			local v178 = v66

			v178.current = v178.current + 1

			local current = v66.current

			v67.current = n6

			if placeId ~= nil then
				v91(placeId, "Loading")
			end

			local v180 = creatorAgentChat.createResumedAssistantTurn(v56, p13, function(p14) -- line: 630
				-- upvalues: v97 (copy), current (copy), v56 (copy)
				v97(current, p14, nil, v56)
			end, if n6 == nil then nil else n6 - 1)

			v68(v180)
			v180.start()
			v88.scrollToBottomUnconditionally()
		end

		if v76.activeTurnState ~= nil and v76.activeTurnItemIndex ~= nil and not v76.activeTurnState.isDone then
			local activeTurnStartSequenceId = v76.activeTurnStartSequenceId

			if activeTurnStartSequenceId == v67.current and v63 ~= nil then
				return
			end

			local v141 = v55.resumeTurnFromHistory(v136, v76.activeTurnState, v76.activeTurnSequenceIds)

			if v141 ~= nil then
				attachResumedTurn(v141, activeTurnStartSequenceId)
			end

			return
		end

		v67.current = nil

		local v142 = v55.getActiveTurnHandle(v136)
		local v143 = if v142 == nil then nil else v142.state(false)
		local v144 = v142 ~= nil and (v143 ~= nil and not v143.isDone)

		if not v90 and not v144 then
			return
		end

		if v144 then
			attachResumedTurn(v142, nil)
		end
	end, {
		v76,
		v56,
		v55,
		v90,
		v63,
		placeId,
		v91,
		v97,
		v88,
		v68,
		v61
	})

	local v99 = React.useCallback(function(p15, s5: string, n7: number, n8: number?) -- line: 691
		-- upvalues: v60 (copy), creatorAgentChat (copy), v97 (copy), v91 (copy), v68 (copy), v88 (copy)
		v60({
			text = s5,
			afterSequenceId = n8
		})

		local v149 = creatorAgentChat.createLiveAssistantTurn(p15, s5, function(p16) -- line: 698
			-- upvalues: v97 (copy), n7 (copy), s5 (copy), p15 (copy)
			v97(n7, p16, s5, p15)
		end)

		if p15.placeId ~= nil then
			v91(p15.placeId, "Loading")
		end

		v68(v149)
		v88.scrollToBottomAfterSend()
		v149.start()
	end, {
		v97,
		v91,
		v88,
		v68,
		v60
	})
	local v100 = React.useCallback(function(s6: string, n9: number, n10: number?) -- line: 720
		-- upvalues: v60 (copy), UniverseCreate (copy), getDefaultTemplatePlaceId (copy), debug (copy), v66 (copy), UniverseConfiguration (copy), v50 (copy), t4 (copy), v55 (copy), sessionId (ref), v99 (copy), v68 (copy), v96 (copy), v84 (copy), CHAT_CREATE_UNIVERSE_ERROR (copy)
		v60({
			text = s6,
			afterSequenceId = n10
		})

		local elapsed = os.clock()

		UniverseCreate.getUniverseCreateStore().createUniverse({
			isPublish = true,
			templatePlaceId = getDefaultTemplatePlaceId()
		}):andThen(function(p17) -- line: 728
			-- upvalues: debug (copy), elapsed (copy), v66 (copy), n9 (copy), UniverseConfiguration (copy), v50 (copy), t4 (copy), v55 (copy), sessionId (ref), v99 (copy), s6 (copy), n10 (copy)
			debug.log("info", "build_experience create_universe succeeded", {
				durationMs = math.floor((os.clock() - elapsed) * 1000 + 0.5),
				universeId = p17.universeId,
				rootPlaceId = p17.rootPlaceId
			})

			if v66.current ~= n9 then
				return nil
			end

			local v183 = UniverseConfiguration.getUniverseConfigurationStore()

			return v183.patchConfiguration(p17.universeId, {
				audiences = { 1 }
			}):andThen(function() -- line: 743
				-- upvalues: v183 (copy), p17 (copy)
				return v183.setTeamCreate(p17.universeId, true)
			end):andThen(function() -- line: 746
				-- upvalues: v66 (copy), n9 (copy), p17 (copy), v50 (copy), t4 (copy), v55 (copy), sessionId (ref), v99 (copy), s6 (copy), n10 (copy)
				if v66.current ~= n9 then
					return nil
				end

				local t6 = {
					universeId = p17.universeId,
					placeId = p17.rootPlaceId
				}

				v50(t6)

				if t4.onProjectResolved ~= nil then
					t4.onProjectResolved(t6)
				end

				local v188 = v55.getSessionForProject(p17.universeId, p17.rootPlaceId, sessionId)

				v99(v188, s6, n9, n10)

				return nil
			end)
		end):catch(function(p18) -- line: 769
			-- upvalues: debug (copy), elapsed (copy), v66 (copy), n9 (copy), v68 (copy), v60 (copy), v96 (copy), s6 (copy), v84 (copy), CHAT_CREATE_UNIVERSE_ERROR (copy)
			debug.log("warn", "build_experience create_or_configure_universe failed", {
				durationMs = math.floor((os.clock() - elapsed) * 1000 + 0.5),
				error = p18
			})

			if v66.current ~= n9 then
				return
			end

			v68(nil)
			v60(nil)
			v96(s6)
			v84(CHAT_CREATE_UNIVERSE_ERROR)
		end)
	end, {
		sessionId,
		v55,
		t4.onProjectResolved,
		v68,
		v96,
		v84,
		v50,
		v60,
		v99
	})
	local v101 = React.useCallback(function() -- line: 797
		-- upvalues: v85 (copy), v96 (copy), v90 (copy), v65 (copy), v86 (copy), v88 (copy), t4 (copy), universeId (ref), v56 (copy), v66 (copy), v62 (copy), v100 (copy), v76 (copy), v99 (copy)
		local current = v85.current
		local v155 = string.gsub(current, "^%s*(.-)%s*$", "%1")

		if v155 == "" then
			v96("")

			return false
		end

		if v90 then
			local current2 = v65.current

			if current2 ~= nil and current2.trySubmitComposerText(v155) then
				v96("")

				if v86.current then
					v86.current.releaseFocus()
				end

				v88.scrollToBottomAfterSend()

				return true
			end

			return false
		end

		local v157 = t4.createUniverseOnFirstPrompt == true and universeId == nil

		if not v157 and v56 == nil then
			return false
		end

		v88.captureStickToBottomForSend()

		local v158 = v66

		v158.current = v158.current + 1

		local current3 = v66.current

		v62(nil)
		v96("")

		if v86.current then
			v86.current.releaseFocus()
		end

		if v157 then
			v100(v155, current3, v76.latestSequenceId)
		else
			v99(v56, v155, current3, v76.latestSequenceId)
		end

		return true
	end, {
		v56,
		universeId,
		v90,
		v88,
		v96,
		v100,
		v99,
		t4.createUniverseOnFirstPrompt,
		v62,
		v76
	})
	local v102 = React.useCallback(function() -- line: 851
		-- upvalues: v65 (copy), v66 (copy), v68 (copy), v67 (copy), v60 (copy), v62 (copy), v76 (copy), placeId (ref), v91 (copy)
		local current = v65.current

		if current == nil then
			return
		end

		local v161 = v66

		v161.current = v161.current + 1
		current.stop()
		v68(nil)
		v67.current = nil
		v60(nil)
		v62({
			startSequenceId = v76.activeTurnStartSequenceId
		})

		if placeId ~= nil then
			v91(placeId, "Idle")
		end
	end, {
		placeId,
		v91,
		v68,
		v60,
		v62,
		v76
	})
	local v103 = t4.autoFocusComposer == nil or t4.autoFocusComposer
	local v104 = if t4.focusComposerWhen ~= nil then t4.focusComposerWhen else v103

	React.useEffect(function() -- line: 878
		-- upvalues: v103 (copy), v104 (copy), v86 (copy)
		if not v103 or not v104 then
			return function() -- line: 880
			end
		end

		local u162 = false
		local v163 = v86

		local function v164() -- line: 883
			-- upvalues: u162 (ref)
			return u162
		end

		local n11 = 8

		local function tryFocus() -- line: 130
			-- upvalues: v164 (copy), v163 (copy), n11 (ref), tryFocus (copy)
			if v164() then
				return
			end

			local current = v163.current

			if current then
				current.focus()

				return
			end

			n11 -= 1

			if n11 > 0 then
				task.delay(0, tryFocus)
			end
		end

		task.defer(tryFocus)

		return function() -- line: 886
			-- upvalues: u162 (ref)
			u162 = true
		end
	end, {
		v103,
		v104
	})

	local v105 = React.useCallback(function(s7: string) -- line: 891
		-- upvalues: placeId (ref), launchPlaytestWithLoadingState (copy)
		if placeId == nil then
			return
		end

		launchPlaytestWithLoadingState(placeId, s7, true)
	end, { placeId })

	return {
		messages = messages,
		localToolActions = v73,
		composerText = v81,
		composerErrorText = v83,
		setComposerText = v96,
		isAssistantResponding = v90,
		canStopAssistantResponse = v63 ~= nil,
		sendMessage = v101,
		stopAssistantResponse = v102,
		setScrollingFrame = v88.setScrollingFrame,
		textBoxRef = v86,
		clockBinding = v87,
		playtestPlaceId = placeId,
		launchPlaytest = if placeId == nil then nil else v105,
		hasPublishedTurn = includesPublishTool,
		subagentTaskState = subagentTaskState
	}
end

return useChatSessionCore
