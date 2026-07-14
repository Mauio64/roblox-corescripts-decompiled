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

require(script.Parent.chatTypes)

local creatorAgentChat = require(script.Parent.creatorAgentChat)
local parseSessionStream = require(script.Parent.parseSessionStream)
local useChatScroll = require(script.Parent.useChatScroll)
local GetPlaytestLoadingStore = require(BuildExperience.Stores.GetPlaytestLoadingStore)

require(BuildExperience.Stores.GetPlaytestLoadingStore.createPlaytestLoadingStore)

local getDefaultTemplatePlaceId = require(BuildExperience.utils.getDefaultTemplatePlaceId)
local launchPlaytestWithLoadingState = require(BuildExperience.utils.launchPlaytestWithLoadingState)
local debug = CreatorAgentChat.debug
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
local v23 = Signals.createSignal(t1)
local v24 = Signals.createSignal(t2)
local v25 = Signals.createSignal(nil)
local v26 = Signals.createSignal({})

local function getIsAssistantRespondingForPlaceId(p1, n1: number?) -- line: 108
	-- upvalues: GetPlaytestLoadingStore (copy)
	local v35 = GetPlaytestLoadingStore(p1)

	if n1 == nil then
		return false
	end

	return v35.getAgentStatusForPlaceId(n1)(p1) == "Loading"
end
local function trimMessage(s1: string) -- line: 116
	return string.gsub(s1, "^%s*(.-)%s*$", "%1")
end
local function refreshVersionHistoryAfterPublish(n2: number?) -- line: 120
	-- upvalues: PlaceVersionHistory (copy)
	if n2 == nil then
		return
	end

	PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(n2)
end
local function scheduleComposerAutoFocus(t3: {[any]: any}, p2: ((...any) -> ...any)) -- line: 127
	local n3 = 8

	local function tryFocus() -- line: 129
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
local function getResumeSessionKey(p3) -- line: 146
	local v43 = p3.getCasSessionId()

	if typeof(v43) == "string" and v43 ~= "" then
		return v43
	end

	local universeId = p3.universeId
	local placeId = p3.placeId

	if universeId ~= nil and placeId ~= nil then
		return `{ universeId }:{ placeId }`
	end

	return nil
end
local function useChatSessionCore(t4: {[any]: any}) -- line: 159
	-- upvalues: React (copy), CreatorAgentChat (copy), v26 (copy), SignalsReact (copy), v23 (copy), v24 (copy), v25 (copy), parseSessionStream (copy), PlaceVersionHistory (copy), ReactUtils (copy), useChatScroll (copy), GetPlaytestLoadingStore (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy), creatorAgentChat (copy), UniverseCreate (copy), getDefaultTemplatePlaceId (copy), debug (copy), UniverseConfiguration (copy), launchPlaytestWithLoadingState (copy)
	local v47, v48 = React.useState(nil)
	local placeId = t4.placeId
	local universeId = t4.universeId
	local sessionId = t4.sessionId

	if v47 ~= nil then
		placeId = v47.placeId
		universeId = v47.universeId
		sessionId = v47.sessionId
	end

	local v52 = t4.hydrateHistoryWhen == nil or t4.hydrateHistoryWhen
	local v53 = CreatorAgentChat.getCreatorAgentChatStore()
	local v54 = React.useMemo(function() -- line: 172
		-- upvalues: universeId (ref), v53 (copy), placeId (ref), sessionId (ref)
		if universeId == nil then
			return nil
		end

		return v53.getSessionForProject(universeId, placeId, sessionId)
	end, {
		universeId,
		placeId,
		sessionId,
		v53
	})

	React.useLayoutEffect(function() -- line: 179
		-- upvalues: v54 (copy), sessionId (ref)
		if v54 == nil or (sessionId == nil or sessionId == "") then
			return
		end

		v54.setCasSessionId(sessionId)
	end, {
		v54,
		sessionId
	})

	local v55 = if v54 == nil then v26 else v54.getMergedHistory
	local v56 = SignalsReact.useSignalState(v55)
	local v57, v58 = React.useState(nil)
	local v59, v60 = React.useState(nil)

	React.useEffect(function() -- line: 204
		-- upvalues: v60 (copy)
		v60(nil)
	end, { v54 })

	local v61, v62 = React.useState(nil)
	local v63 = React.useRef(nil)
	local v64 = React.useRef(0)
	local v65 = React.useRef(nil)
	local v66 = React.useCallback(function(p4) -- line: 214
		-- upvalues: v63 (copy), v62 (copy)
		v63.current = p4
		v62(p4)
	end, { v62 })
	local v67 = if v61 == nil then v23 else v61.getOptimisticLocalTools
	local v68 = if v61 == nil then v24 else v61.getLocalToolActions
	local v69 = if v61 == nil then v25 else v61.getSetupErrorText
	local v70 = SignalsReact.useSignalState(v67)
	local v71 = SignalsReact.useSignalState(v68)
	local v72 = SignalsReact.useSignalState(v69)
	local v73 = React.useMemo(function() -- line: 235
		-- upvalues: v61 (copy), v72 (copy)
		if v61 == nil then
			return nil
		end

		return {
			setupErrorText = v72
		}
	end, {
		v61,
		v72
	})
	local v74 = React.useMemo(function() -- line: 243
		-- upvalues: parseSessionStream (copy), v56 (copy), v54 (copy), sessionId (ref), universeId (ref), placeId (ref), v70 (copy), v57 (copy), v73 (copy), v59 (copy)
		return parseSessionStream(v56, {
			sessionId = if v54 == nil then sessionId else v54.getCasSessionId() or sessionId,
			universeId = if v54 == nil then universeId else v54.universeId,
			placeId = if v54 == nil then placeId else v54.placeId,
			optimisticLocalTools = v70,
			pendingUserMessage = if v57 == nil then nil else v57.text,
			pendingUserMessageAfterSequenceId = if v57 == nil then nil else v57.afterSequenceId,
			liveAssistantMessage = v73,
			optimisticCancelledStartSequenceId = if v59 == nil then nil else v59.startSequenceId
		})
	end, {
		v56,
		v54,
		sessionId,
		universeId,
		placeId,
		v70,
		v57,
		v73,
		v59
	})
	local messages = v74.messages
	local subagentTaskState = v74.subagentTaskState
	local includesPublishTool = v74.includesPublishTool
	local activeTurnState = v74.activeTurnState

	React.useEffect(function() -- line: 282
		-- upvalues: v61 (copy), activeTurnState (copy)
		if v61 == nil or activeTurnState == nil then
			return
		end

		v61.syncFromTurnState(activeTurnState)
	end, {
		v61,
		activeTurnState
	})
	React.useEffect(function() -- line: 289
		-- upvalues: v74 (copy), placeId (ref), PlaceVersionHistory (copy)
		if not v74.includesPublishTool then
			return
		end

		local v106 = placeId

		if v106 == nil then
			return
		end

		PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(v106)
	end, {
		v74.includesPublishTool,
		placeId
	})

	local v79, v80 = React.useBinding("")
	local v81, v82 = React.useState(nil)
	local v83 = React.useRef("")
	local v84 = React.useRef(nil)
	local v85 = ReactUtils.useClock()
	local v86 = useChatScroll()
	local v87 = React.useCallback(function(p5) -- line: 304
		-- upvalues: placeId (ref), GetPlaytestLoadingStore (copy)
		local v108 = placeId
		local v109 = GetPlaytestLoadingStore(p5)

		if v108 == nil then
			return false
		end

		return v109.getAgentStatusForPlaceId(v108)(p5) == "Loading"
	end, { placeId })
	local v88 = SignalsReact.useSignalState(v87)
	local v89 = React.useCallback(function(n4: number, p6) -- line: 308
		-- upvalues: GetPlaytestLoadingStore (copy)
		GetPlaytestLoadingStore().setAgentStatusForPlaceId(n4, p6)
	end, {})
	local v90 = React.useCallback(function(p7: ((...any) -> ...any)?) -- line: 312
		-- upvalues: v86 (copy), v54 (copy)
		local function v113() -- line: 313
			-- upvalues: p7 (copy)
			if p7 ~= nil then
				return p7()
			end

			return false
		end

		v86.captureDistanceFromBottom()
		task.spawn(function() -- line: 320
			-- upvalues: v54 (copy), v113 (copy), v86 (copy), p7 (copy)
			if v54 == nil then
				return
			end

			if v54.loadOlderHistory(v113) and v54.getNextHistoryPageToken() ~= nil and v86.isAtTopRef.current then
				task.delay(0.1, function() -- line: 326
					-- upvalues: p7 (copy), v86 (copy), v54 (copy), v113 (copy)
					if p7 ~= nil and p7() then
						return
					end

					if v86.isViewportUnderfilled() then
						v54.loadOlderHistory(v113)
					end
				end)
			end
		end)
	end, {
		v54,
		v86
	})
	local v91 = React.useCallback(function(p8: ((...any) -> ...any)) -- line: 338
		-- upvalues: v54 (copy), v86 (copy), v90 (copy)
		task.delay(0.1, function() -- line: 339
			-- upvalues: p8 (copy), v54 (copy), v86 (copy), v90 (copy)
			if p8() then
				return
			end

			if v54 == nil then
				return
			end

			if v54.getNextHistoryPageToken() == nil then
				return
			end

			if not v86.isViewportUnderfilled() then
				return
			end

			v90(p8)
		end)
	end, {
		v90,
		v86,
		v54
	})
	local v92 = React.useCallback(function(p9: ((...any) -> ...any)) -- line: 357
		-- upvalues: v54 (copy), v91 (copy)
		if v54 == nil then
			return
		end

		if v54.getNextHistoryPageToken() == nil then
			return
		end

		v91(p9)
	end, {
		v91,
		v54
	})
	local v93 = React.useRef(v92)

	v93.current = v92
	React.useEffect(function() -- line: 369
		-- upvalues: v86 (copy), v90 (copy)
		v86.setOnScrolledToTop(function() -- line: 370
			-- upvalues: v90 (copy)
			v90(nil)
		end)

		return function() -- line: 373
			-- upvalues: v86 (copy)
			v86.setOnScrolledToTop(nil)
		end
	end, {
		v86.setOnScrolledToTop,
		v90
	})
	React.useEffect(function() -- line: 378
		-- upvalues: v52 (copy), v54 (copy), sessionId (ref), v93 (copy), universeId (ref), v53 (copy)
		if not v52 or v54 == nil then
			return
		end

		local u116 = false
		local u117 = sessionId

		local function isHydrateCancelled() -- line: 385
			-- upvalues: u116 (ref), u117 (ref), v54 (copy)
			if u116 then
				return true
			end

			if u117 ~= nil and u117 ~= "" then
				return v54.getCasSessionId() ~= u117
			end

			return false
		end
		local function continueAfterSessionReady() -- line: 394
			-- upvalues: u116 (ref), u117 (ref), v54 (copy), v93 (copy), isHydrateCancelled (copy)
			if not not u116 or u117 ~= nil and (u117 ~= "" and v54.getCasSessionId() ~= u117) then
				return
			end

			v93.current(isHydrateCancelled)
		end
		local function hydrateKnownSession(s2: string) -- line: 401
			-- upvalues: v54 (copy), u116 (ref), u117 (ref), v93 (copy), isHydrateCancelled (copy)
			v54.setCasSessionId(s2)

			if v54.hasLoadedHistory() and #v54.getMergedHistory(false) > 0 then
				if not not u116 or u117 ~= nil and (u117 ~= "" and v54.getCasSessionId() ~= u117) then
					return
				end

				v93.current(isHydrateCancelled)

				return
			end

			if v54.refreshSession(isHydrateCancelled) and (not u116 and (u117 == nil or (u117 == "" or v54.getCasSessionId() == u117))) then
				if not not u116 or u117 ~= nil and (u117 ~= "" and v54.getCasSessionId() ~= u117) then
					return
				end

				v93.current(isHydrateCancelled)
			end
		end

		task.spawn(function() -- line: 412
			-- upvalues: sessionId (ref), hydrateKnownSession (copy), universeId (ref), v54 (copy), v53 (copy), u116 (ref), u117 (ref)
			if sessionId ~= nil and sessionId ~= "" then
				hydrateKnownSession(sessionId)

				return
			end

			if universeId == nil or universeId == 0 or v54.hasLoadedHistory() and #v54.getMergedHistory(false) > 0 then
				return
			end

			local v167 = v53.sessionFindByUniverse({
				sort = "desc",
				universeId = universeId
			})

			while v167.state(false).status == "pending" and (not u116 and (u117 == nil or (u117 == "" or v54.getCasSessionId() == u117))) do
				task.wait()
			end

			if u116 or u117 ~= nil and (u117 ~= "" and v54.getCasSessionId() ~= u117) or v167.state(false).status ~= "succeeded" then
				return
			end

			local result = v167.state(false).result
			local v169 = if result == nil then nil else result.sessions
			local v170 = if typeof(v169) ~= "table" then nil else v169[1]
			local v171 = if typeof(v170) ~= "table" then nil else v170.sessionId

			if typeof(v171) ~= "string" or v171 == "" then
				v54.markHistoryLoaded()

				return
			end

			u117 = v171
			hydrateKnownSession(v171)
		end)

		return function() -- line: 450
			-- upvalues: u116 (ref)
			u116 = true
		end
	end, {
		v54,
		sessionId,
		universeId,
		v53,
		v52
	})
	React.useEffect(function() -- line: 455
		-- upvalues: v54 (copy), sessionId (ref), v93 (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy)
		if v54 == nil then
			return
		end

		local u121 = false

		local function refreshKnownSession() -- line: 460
			-- upvalues: v54 (copy), sessionId (ref), u121 (ref), v93 (copy)
			local v172 = v54.getCasSessionId()

			if (v172 == nil or v172 == "") and (sessionId ~= nil and sessionId ~= "") then
				v172 = sessionId
			end

			if v172 == nil or v172 == "" then
				return
			end

			task.spawn(function() -- line: 468
				-- upvalues: v54 (copy), u121 (ref), v93 (copy)
				if v54.refreshSession(function() -- line: 469
					-- upvalues: u121 (ref)
					return u121
				end) and not u121 then
					v93.current(function() -- line: 472
						-- upvalues: u121 (ref)
						return u121
					end)
				end
			end)
		end

		local v123 = MessageBusService:Subscribe(MessageId, function(_) -- line: 479
			-- upvalues: refreshKnownSession (copy)
			refreshKnownSession()
		end, false, true)
		local connection = AppLifecycleObserverService.OnUnhide:Connect(refreshKnownSession)

		return function() -- line: 484
			-- upvalues: u121 (ref), v123 (copy), connection (copy)
			u121 = true
			v123:Disconnect()
			connection:Disconnect()
		end
	end, {
		v54,
		sessionId
	})

	local v94 = React.useCallback(function(s3: string) -- line: 491
		-- upvalues: v83 (copy), v80 (copy), v82 (copy)
		v83.current = s3
		v80(s3)
		v82(nil)
	end, {
		v80,
		v82
	})
	local v95 = React.useCallback(function(n5: number, p11, s4: string?, p12) -- line: 498
		-- upvalues: v64 (copy), v66 (copy), v65 (copy), v58 (copy), v89 (copy), v94 (copy), v82 (copy), creatorAgentChat (copy), v86 (copy), t4 (copy), sessionId (ref), v48 (copy)
		if n5 ~= v64.current then
			return
		end

		v66(nil)
		v65.current = nil
		v58(nil)

		if p11 ~= nil then
			if p12.placeId ~= nil then
				v89(p12.placeId, "Idle")
			end

			if s4 ~= nil then
				v94(s4)
				v82(creatorAgentChat.getPromptFailureComposerError(p11))
			end

			task.spawn(function() -- line: 522
				-- upvalues: p12 (copy), v64 (copy), n5 (copy)
				p12.refreshSession(function() -- line: 523
					-- upvalues: v64 (copy), n5 (copy)
					return v64.current ~= n5
				end)
			end)

			return
		end

		if p12.placeId ~= nil then
			v89(p12.placeId, "Completed")
		end

		v86.scrollToBottomAfterSend()

		local v130 = p12.getCasSessionId()

		if v130 ~= nil and v130 ~= "" then
			if t4.createUniverseOnFirstPrompt and sessionId == nil and p12.universeId ~= nil then
				local t5 = {
					universeId = p12.universeId,
					placeId = p12.placeId,
					sessionId = v130
				}

				v48(t5)

				if t4.onProjectResolved ~= nil then
					t4.onProjectResolved(t5)
				end
			end

			task.spawn(function() -- line: 551
				-- upvalues: p12 (copy), v64 (copy), n5 (copy)
				p12.refreshSession(function() -- line: 552
					-- upvalues: v64 (copy), n5 (copy)
					return v64.current ~= n5
				end)
			end)
		end
	end, {
		t4.createUniverseOnFirstPrompt,
		t4.onProjectResolved,
		sessionId,
		v89,
		v48,
		v86,
		v94,
		v82,
		v66,
		v58
	})
	local v96 = React.useRef(v52)

	React.useEffect(function() -- line: 574
		-- upvalues: v52 (copy), v96 (copy), v88 (copy), v61 (copy), v86 (copy)
		local v132 = v52 and not v96.current

		v96.current = v52

		if not v52 then
			return
		end

		if not v132 and not v88 and v61 == nil then
			return
		end

		v86.scrollToBottomUnconditionally()
		task.defer(v86.scrollToBottomUnconditionally)
		task.delay(0.15, v86.scrollToBottomUnconditionally)
	end, {
		v52,
		v88,
		v61,
		#messages,
		v86
	})
	React.useEffect(function() -- line: 600
		-- upvalues: v63 (copy), v59 (copy), v54 (copy), v64 (copy), v65 (copy), placeId (ref), v89 (copy), creatorAgentChat (copy), v95 (copy), v66 (copy), v86 (copy), v74 (copy), v61 (copy), v53 (copy), v88 (copy)
		if v63.current ~= nil then
			return
		end

		if v59 ~= nil then
			return
		end

		if v54 == nil then
			return
		end

		local v133 = v54
		local v134 = v133.getCasSessionId()

		if typeof(v134) == "string" and v134 ~= "" then
		else
			local universeId2 = v133.universeId
			local placeId2 = v133.placeId

			v134 = if universeId2 == nil or placeId2 == nil then nil else `{ universeId2 }:{ placeId2 }`
		end

		if v134 == nil then
			return
		end

		local function attachResumedTurn(p13, n6: number?) -- line: 619
			-- upvalues: v64 (copy), v65 (copy), placeId (ref), v89 (copy), creatorAgentChat (copy), v54 (copy), v95 (copy), v66 (copy), v86 (copy)
			local v176 = v64

			v176.current = v176.current + 1

			local current = v64.current

			v65.current = n6

			if placeId ~= nil then
				v89(placeId, "Loading")
			end

			local v178 = creatorAgentChat.createResumedAssistantTurn(v54, p13, function(p14) -- line: 629
				-- upvalues: v95 (copy), current (copy), v54 (copy)
				v95(current, p14, nil, v54)
			end, if n6 == nil then nil else n6 - 1)

			v66(v178)
			v178.start()
			v86.scrollToBottomUnconditionally()
		end

		if v74.activeTurnState ~= nil and v74.activeTurnItemIndex ~= nil and not v74.activeTurnState.isDone then
			local activeTurnStartSequenceId = v74.activeTurnStartSequenceId

			if activeTurnStartSequenceId == v65.current and v61 ~= nil then
				return
			end

			local v139 = v53.resumeTurnFromHistory(v134, v74.activeTurnState, v74.activeTurnSequenceIds)

			if v139 ~= nil then
				attachResumedTurn(v139, activeTurnStartSequenceId)
			end

			return
		end

		v65.current = nil

		local v140 = v53.getActiveTurnHandle(v134)
		local v141 = if v140 == nil then nil else v140.state(false)
		local v142 = v140 ~= nil and (v141 ~= nil and not v141.isDone)

		if not v88 and not v142 then
			return
		end

		if v142 then
			attachResumedTurn(v140, nil)
		end
	end, {
		v74,
		v54,
		v53,
		v88,
		v61,
		placeId,
		v89,
		v95,
		v86,
		v66,
		v59
	})

	local v97 = React.useCallback(function(p15, s5: string, n7: number, n8: number?) -- line: 690
		-- upvalues: v58 (copy), creatorAgentChat (copy), v95 (copy), v89 (copy), v66 (copy), v86 (copy)
		v58({
			text = s5,
			afterSequenceId = n8
		})

		local v147 = creatorAgentChat.createLiveAssistantTurn(p15, s5, function(p16) -- line: 697
			-- upvalues: v95 (copy), n7 (copy), s5 (copy), p15 (copy)
			v95(n7, p16, s5, p15)
		end)

		if p15.placeId ~= nil then
			v89(p15.placeId, "Loading")
		end

		v66(v147)
		v86.scrollToBottomAfterSend()
		v147.start()
	end, {
		v95,
		v89,
		v86,
		v66,
		v58
	})
	local v98 = React.useCallback(function(s6: string, n9: number, n10: number?) -- line: 719
		-- upvalues: v58 (copy), UniverseCreate (copy), getDefaultTemplatePlaceId (copy), debug (copy), v64 (copy), UniverseConfiguration (copy), v48 (copy), t4 (copy), v53 (copy), sessionId (ref), v97 (copy), v66 (copy), v94 (copy), v82 (copy)
		v58({
			text = s6,
			afterSequenceId = n10
		})

		local elapsed = os.clock()

		UniverseCreate.getUniverseCreateStore().createUniverse({
			isPublish = true,
			templatePlaceId = getDefaultTemplatePlaceId()
		}):andThen(function(p17) -- line: 727
			-- upvalues: debug (copy), elapsed (copy), v64 (copy), n9 (copy), UniverseConfiguration (copy), v48 (copy), t4 (copy), v53 (copy), sessionId (ref), v97 (copy), s6 (copy), n10 (copy)
			debug.log("info", "build_experience create_universe succeeded", {
				durationMs = math.floor((os.clock() - elapsed) * 1000 + 0.5),
				universeId = p17.universeId,
				rootPlaceId = p17.rootPlaceId
			})

			if v64.current ~= n9 then
				return nil
			end

			local v181 = UniverseConfiguration.getUniverseConfigurationStore()

			return v181.patchConfiguration(p17.universeId, {
				audiences = { 1 }
			}):andThen(function() -- line: 742
				-- upvalues: v181 (copy), p17 (copy)
				return v181.setTeamCreate(p17.universeId, true)
			end):andThen(function() -- line: 745
				-- upvalues: v64 (copy), n9 (copy), p17 (copy), v48 (copy), t4 (copy), v53 (copy), sessionId (ref), v97 (copy), s6 (copy), n10 (copy)
				if v64.current ~= n9 then
					return nil
				end

				local t6 = {
					universeId = p17.universeId,
					placeId = p17.rootPlaceId
				}

				v48(t6)

				if t4.onProjectResolved ~= nil then
					t4.onProjectResolved(t6)
				end

				local v186 = v53.getSessionForProject(p17.universeId, p17.rootPlaceId, sessionId)

				v97(v186, s6, n9, n10)

				return nil
			end)
		end):catch(function(p18) -- line: 768
			-- upvalues: debug (copy), elapsed (copy), v64 (copy), n9 (copy), v66 (copy), v58 (copy), v94 (copy), s6 (copy), v82 (copy)
			debug.log("warn", "build_experience create_or_configure_universe failed", {
				durationMs = math.floor((os.clock() - elapsed) * 1000 + 0.5),
				error = p18
			})

			if v64.current ~= n9 then
				return
			end

			v66(nil)
			v58(nil)
			v94(s6)
			v82("The assistant couldn't create an experience. Please try again.")
		end)
	end, {
		sessionId,
		v53,
		t4.onProjectResolved,
		v66,
		v94,
		v82,
		v48,
		v58,
		v97
	})
	local v99 = React.useCallback(function() -- line: 796
		-- upvalues: v83 (copy), v94 (copy), v88 (copy), v63 (copy), v84 (copy), v86 (copy), t4 (copy), universeId (ref), v54 (copy), v64 (copy), v60 (copy), v98 (copy), v74 (copy), v97 (copy)
		local current = v83.current
		local v153 = string.gsub(current, "^%s*(.-)%s*$", "%1")

		if v153 == "" then
			v94("")

			return false
		end

		if v88 then
			local current2 = v63.current

			if current2 ~= nil and current2.trySubmitComposerText(v153) then
				v94("")

				if v84.current then
					v84.current.releaseFocus()
				end

				v86.scrollToBottomAfterSend()

				return true
			end

			return false
		end

		local v155 = t4.createUniverseOnFirstPrompt == true and universeId == nil

		if not v155 and v54 == nil then
			return false
		end

		v86.captureStickToBottomForSend()

		local v156 = v64

		v156.current = v156.current + 1

		local current3 = v64.current

		v60(nil)
		v94("")

		if v84.current then
			v84.current.releaseFocus()
		end

		if v155 then
			v98(v153, current3, v74.latestSequenceId)
		else
			v97(v54, v153, current3, v74.latestSequenceId)
		end

		return true
	end, {
		v54,
		universeId,
		v88,
		v86,
		v94,
		v98,
		v97,
		t4.createUniverseOnFirstPrompt,
		v60,
		v74
	})
	local v100 = React.useCallback(function() -- line: 850
		-- upvalues: v63 (copy), v64 (copy), v66 (copy), v65 (copy), v58 (copy), v60 (copy), v74 (copy), placeId (ref), v89 (copy)
		local current = v63.current

		if current == nil then
			return
		end

		local v159 = v64

		v159.current = v159.current + 1
		current.stop()
		v66(nil)
		v65.current = nil
		v58(nil)
		v60({
			startSequenceId = v74.activeTurnStartSequenceId
		})

		if placeId ~= nil then
			v89(placeId, "Idle")
		end
	end, {
		placeId,
		v89,
		v66,
		v58,
		v60,
		v74
	})
	local v101 = t4.autoFocusComposer == nil or t4.autoFocusComposer
	local v102 = if t4.focusComposerWhen ~= nil then t4.focusComposerWhen else v101

	React.useEffect(function() -- line: 877
		-- upvalues: v101 (copy), v102 (copy), v84 (copy)
		if not v101 or not v102 then
			return function() -- line: 879
			end
		end

		local u160 = false
		local v161 = v84

		local function v162() -- line: 882
			-- upvalues: u160 (ref)
			return u160
		end

		local n11 = 8

		local function tryFocus() -- line: 129
			-- upvalues: v162 (copy), v161 (copy), n11 (ref), tryFocus (copy)
			if v162() then
				return
			end

			local current = v161.current

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

		return function() -- line: 885
			-- upvalues: u160 (ref)
			u160 = true
		end
	end, {
		v101,
		v102
	})

	local v103 = React.useCallback(function(s7: string) -- line: 890
		-- upvalues: placeId (ref), launchPlaytestWithLoadingState (copy)
		if placeId == nil then
			return
		end

		launchPlaytestWithLoadingState(placeId, s7, true)
	end, { placeId })

	return {
		messages = messages,
		localToolActions = v71,
		composerText = v79,
		composerErrorText = v81,
		setComposerText = v94,
		isAssistantResponding = v88,
		canStopAssistantResponse = v61 ~= nil,
		sendMessage = v99,
		stopAssistantResponse = v100,
		setScrollingFrame = v86.setScrollingFrame,
		textBoxRef = v84,
		clockBinding = v85,
		playtestPlaceId = placeId,
		launchPlaytest = if placeId == nil then nil else v103,
		hasPublishedTurn = includesPublishTool,
		subagentTaskState = subagentTaskState
	}
end

return useChatSessionCore
