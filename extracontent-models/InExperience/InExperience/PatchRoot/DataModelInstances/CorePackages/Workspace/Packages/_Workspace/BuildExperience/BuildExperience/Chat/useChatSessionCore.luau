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
local FFlagBuildExperienceToolResultFailureRecovery = require(BuildExperience.Flags.FFlagBuildExperienceToolResultFailureRecovery)

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
local v26 = Signals.createSignal(t1)
local v27 = Signals.createSignal(t2)
local v28 = Signals.createSignal(nil)
local v29 = Signals.createSignal({
	session = nil,
	sessionId = nil,
	events = {}
})

local function sessionOwnerMatches(t3: {[any]: any}?, p1, s1: string?) -- line: 132
	if t3 == nil or p1 ~= t3.session then
		return false
	end

	if s1 == nil or s1 == "" then
		return true
	end

	return s1 == t3.sessionId or t3.sessionId == nil and s1 == t3.session.getCasSessionId()
end
local function hasPendingLocalToolResponse(p2) -- line: 142
	for v41 in p2.askUserByToolCallId do
		if not p2.submittedToolCallIds[v41] then
			return true
		end
	end

	for v42 in p2.planByToolCallId do
		if not p2.submittedToolCallIds[v42] then
			return true
		end
	end

	return false
end
local function trimMessage(s2: string) -- line: 156
	return string.gsub(s2, "^%s*(.-)%s*$", "%1")
end
local function refreshVersionHistoryAfterPublish(n1: number?) -- line: 160
	-- upvalues: PlaceVersionHistory (copy)
	if n1 == nil then
		return
	end

	PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(n1)
end
local function scheduleComposerAutoFocus(t4: {[any]: any}, p3: ((...any) -> ...any)) -- line: 167
	local n2 = 8

	local function tryFocus() -- line: 169
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
local function getResumeSessionKey(p4) -- line: 186
	local v50 = p4.getCasSessionId()

	if typeof(v50) == "string" and v50 ~= "" then
		return v50
	end

	local universeId = p4.universeId
	local placeId = p4.placeId

	if universeId ~= nil and placeId ~= nil then
		return `{ universeId }:{ placeId }`
	end

	return nil
end
local function useChatSessionCore(t5: {[any]: any}) -- line: 199
	-- upvalues: React (copy), CreatorAgentChat (copy), v29 (copy), Signals (copy), SignalsReact (copy), v26 (copy), v27 (copy), v28 (copy), parseSessionStream (copy), hasPendingLocalToolResponse (copy), PlaceVersionHistory (copy), ReactUtils (copy), useChatScroll (copy), GetPlaytestLoadingStore (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy), FFlagBuildExperienceToolResultFailureRecovery (copy), creatorAgentChat (copy), UniverseCreate (copy), getDefaultTemplatePlaceId (copy), debug (copy), UniverseConfiguration (copy), CHAT_CREATE_UNIVERSE_ERROR (copy), launchPlaytestWithLoadingState (copy)
	local v54, v55 = React.useState(nil)
	local v56, v57 = React.useState(nil)
	local placeId = t5.placeId
	local universeId = t5.universeId
	local sessionId = t5.sessionId

	if v54 ~= nil then
		placeId = v54.placeId
		universeId = v54.universeId
		sessionId = v54.sessionId
	end

	if (sessionId == nil or sessionId == "") and v56 ~= nil and v56.universeId == universeId and v56.placeId == placeId then
		sessionId = v56.sessionId
	end

	local v61 = t5.hydrateHistoryWhen == nil or t5.hydrateHistoryWhen
	local v62 = CreatorAgentChat.getCreatorAgentChatStore()
	local v63 = React.useMemo(function() -- line: 221
		-- upvalues: universeId (ref), v62 (copy), placeId (ref), sessionId (ref)
		if universeId == nil then
			return nil
		end

		return v62.getSessionForProject(universeId, placeId, sessionId)
	end, {
		universeId,
		placeId,
		sessionId,
		v62
	})

	React.useLayoutEffect(function() -- line: 228
		-- upvalues: v63 (copy), sessionId (ref)
		if v63 == nil or (sessionId == nil or sessionId == "") then
			return
		end

		v63.setCasSessionId(sessionId)
	end, {
		v63,
		sessionId
	})

	local v64 = React.useMemo(function() -- line: 235
		-- upvalues: v63 (copy), v29 (copy), Signals (copy)
		if v63 == nil then
			return v29
		end

		return (Signals.createComputed(function(p5) -- line: 240
			-- upvalues: v63 (copy)
			return {
				session = v63,
				sessionId = v63.getCasSessionId(),
				events = v63.getMergedHistory(p5)
			}
		end))
	end, { v63 })
	local v65 = SignalsReact.useSignalState(v64)
	local v66 = if v63 == nil then nil else v63.getCasSessionId()
	local v67 = if v63 ~= v65.session or v66 ~= v65.sessionId then {} else v65.events
	local v68, v69 = React.useState(nil)
	local v70, v71 = React.useState(nil)

	React.useEffect(function() -- line: 270
		-- upvalues: v71 (copy)
		v71(nil)
	end, {
		v63,
		sessionId
	})

	local v72 = sessionId
	local v73 = if not (v70 ~= nil and (v63 == v70.session and (v72 == nil or (v72 == "" or (v72 == v70.sessionId or v70.sessionId == nil and v72 == v70.session.getCasSessionId()))))) then nil else v70
	local v74, v75 = React.useState(nil)
	local v76 = React.useRef(nil)
	local v77 = React.useRef(nil)
	local v78 = React.useRef(0)
	local v79 = React.useRef(nil)
	local v80 = React.useCallback(function(p6, p7) -- line: 285
		-- upvalues: v76 (copy), v77 (copy), v75 (copy)
		assert(p6 == nil or p7 ~= nil, "Active turns require an owning session")
		v76.current = p6
		v77.current = if p6 == nil then nil else {
			session = p7,
			sessionId = p7.getCasSessionId()
		}
		v75(p6)
	end, { v75 })
	local current = v77.current
	local v82 = sessionId
	local v83 = if not (current ~= nil and (v63 == current.session and (v82 == nil or (v82 == "" or (v82 == current.sessionId or current.sessionId == nil and v82 == current.session.getCasSessionId()))))) then nil else v74

	React.useLayoutEffect(function() -- line: 302
		-- upvalues: v74 (copy), v77 (copy), v63 (copy), sessionId (ref), v78 (copy), v79 (copy), v80 (copy), v69 (copy), v71 (copy)
		if v74 ~= nil then
			local current2 = v77.current
			local v127 = v63
			local v128 = sessionId

			if not (current2 ~= nil and (v127 == current2.session and (v128 == nil or (v128 == "" or (v128 == current2.sessionId or current2.sessionId == nil and v128 == current2.session.getCasSessionId()))))) then
				local v129 = v78

				v129.current = v129.current + 1
				v79.current = nil
				v74.detach()
				v80(nil, nil)
				v69(nil)
				v71(nil)

				return
			end
		end
	end, {
		v63,
		sessionId,
		v74,
		v80
	})

	local v84 = if v83 == nil then v26 else v83.getOptimisticLocalTools
	local v85 = if v83 == nil then v27 else v83.getLocalToolActions
	local v86 = if v83 == nil then v28 else v83.getSetupErrorText
	local v87 = SignalsReact.useSignalState(v84)
	local v88 = SignalsReact.useSignalState(v85)
	local v89 = SignalsReact.useSignalState(v86)
	local v90 = React.useMemo(function() -- line: 330
		-- upvalues: v83 (copy), v89 (copy)
		if v83 == nil then
			return nil
		end

		return {
			setupErrorText = v89
		}
	end, {
		v83,
		v89
	})
	local v91 = React.useMemo(function() -- line: 338
		-- upvalues: parseSessionStream (copy), v67 (copy), v63 (copy), sessionId (ref), universeId (ref), placeId (ref), v87 (copy), v68 (copy), v90 (copy), v73 (copy)
		return parseSessionStream(v67, {
			sessionId = if v63 == nil then sessionId else v63.getCasSessionId() or sessionId,
			universeId = if v63 == nil then universeId else v63.universeId,
			placeId = if v63 == nil then placeId else v63.placeId,
			optimisticLocalTools = v87,
			pendingUserMessage = if v68 == nil then nil else v68.text,
			pendingUserMessageAfterSequenceId = if v68 == nil then nil else v68.afterSequenceId,
			liveAssistantMessage = v90,
			optimisticCancelledStartSequenceId = if v73 == nil then nil else v73.startSequenceId
		})
	end, {
		v67,
		v63,
		sessionId,
		universeId,
		placeId,
		v87,
		v68,
		v90,
		v73
	})
	local messages = v91.messages
	local subagentTaskState = v91.subagentTaskState
	local includesPublishTool = v91.includesPublishTool
	local v95 = messages[#messages]
	local v96 = v83 ~= nil or v95 ~= nil and (v95.kind == "assistant_turn" and not v95.isDone)
	local v97 = v96 and hasPendingLocalToolResponse(v87)
	local activeTurnState = v91.activeTurnState

	React.useEffect(function() -- line: 381
		-- upvalues: v83 (copy), activeTurnState (copy)
		if v83 == nil or activeTurnState == nil then
			return
		end

		v83.syncFromTurnState(activeTurnState)
	end, {
		v83,
		activeTurnState
	})
	React.useEffect(function() -- line: 388
		-- upvalues: v91 (copy), placeId (ref), PlaceVersionHistory (copy)
		if not v91.includesPublishTool then
			return
		end

		local v130 = placeId

		if v130 == nil then
			return
		end

		PlaceVersionHistory.getPlaceVersionHistoryStore().fetchHistory(v130)
	end, {
		v91.includesPublishTool,
		placeId
	})

	local v99, v100 = React.useBinding("")
	local v101, v102 = React.useState(nil)
	local v103 = React.useRef("")
	local v104 = React.useRef(nil)
	local v105 = ReactUtils.useClock()
	local v106 = useChatScroll()
	local v107 = React.useCallback(function(n3: number, p8) -- line: 403
		-- upvalues: GetPlaytestLoadingStore (copy)
		GetPlaytestLoadingStore().setAgentStatusForPlaceId(n3, p8)
	end, {})
	local v108 = React.useCallback(function(p9: ((...any) -> ...any)?) -- line: 407
		-- upvalues: v106 (copy), v63 (copy)
		local function v134() -- line: 408
			-- upvalues: p9 (copy)
			if p9 ~= nil then
				return p9()
			end

			return false
		end

		v106.captureDistanceFromBottom()
		task.spawn(function() -- line: 415
			-- upvalues: v63 (copy), v134 (copy), v106 (copy), p9 (copy)
			if v63 == nil then
				return
			end

			if v63.loadOlderHistory(v134) and v63.getNextHistoryPageToken() ~= nil and v106.isAtTopRef.current then
				task.delay(0.1, function() -- line: 421
					-- upvalues: p9 (copy), v106 (copy), v63 (copy), v134 (copy)
					if p9 ~= nil and p9() then
						return
					end

					if v106.isViewportUnderfilled() then
						v63.loadOlderHistory(v134)
					end
				end)
			end
		end)
	end, {
		v63,
		v106
	})
	local v109 = React.useCallback(function(p10: ((...any) -> ...any)) -- line: 433
		-- upvalues: v63 (copy), v106 (copy), v108 (copy)
		task.delay(0.1, function() -- line: 434
			-- upvalues: p10 (copy), v63 (copy), v106 (copy), v108 (copy)
			if p10() then
				return
			end

			if v63 == nil then
				return
			end

			if v63.getNextHistoryPageToken() == nil then
				return
			end

			if not v106.isViewportUnderfilled() then
				return
			end

			v108(p10)
		end)
	end, {
		v108,
		v106,
		v63
	})
	local v110 = React.useCallback(function(p11: ((...any) -> ...any)) -- line: 452
		-- upvalues: v63 (copy), v109 (copy)
		if v63 == nil then
			return
		end

		if v63.getNextHistoryPageToken() == nil then
			return
		end

		v109(p11)
	end, {
		v109,
		v63
	})
	local v111 = React.useRef(v110)

	v111.current = v110
	React.useEffect(function() -- line: 464
		-- upvalues: v106 (copy), v108 (copy)
		v106.setOnScrolledToTop(function() -- line: 465
			-- upvalues: v108 (copy)
			v108(nil)
		end)

		return function() -- line: 468
			-- upvalues: v106 (copy)
			v106.setOnScrolledToTop(nil)
		end
	end, {
		v106.setOnScrolledToTop,
		v108
	})
	React.useEffect(function() -- line: 473
		-- upvalues: v61 (copy), v63 (copy), sessionId (ref), v111 (copy), universeId (ref), v62 (copy), v57 (copy), placeId (ref)
		if not v61 or v63 == nil then
			return
		end

		local u137 = false
		local v138 = sessionId

		local function isHydrateCancelled() -- line: 480
			-- upvalues: u137 (ref), v138 (copy), v63 (copy)
			if u137 then
				return true
			end

			if v138 ~= nil and v138 ~= "" then
				return v63.getCasSessionId() ~= v138
			end

			return false
		end
		local function continueAfterSessionReady() -- line: 489
			-- upvalues: u137 (ref), v138 (copy), v63 (copy), v111 (copy), isHydrateCancelled (copy)
			if not not u137 or v138 ~= nil and (v138 ~= "" and v63.getCasSessionId() ~= v138) then
				return
			end

			v111.current(isHydrateCancelled)
		end
		local function hydrateKnownSession(s3: string) -- line: 496
			-- upvalues: v63 (copy), u137 (ref), v138 (copy), v111 (copy), isHydrateCancelled (copy)
			v63.setCasSessionId(s3)

			if v63.hasLoadedHistory() and #v63.getMergedHistory(false) > 0 then
				if not not u137 or v138 ~= nil and (v138 ~= "" and v63.getCasSessionId() ~= v138) then
					return
				end

				v111.current(isHydrateCancelled)

				return
			end

			if v63.refreshSession(isHydrateCancelled) and (not u137 and (v138 == nil or (v138 == "" or v63.getCasSessionId() == v138))) then
				if not not u137 or v138 ~= nil and (v138 ~= "" and v63.getCasSessionId() ~= v138) then
					return
				end

				v111.current(isHydrateCancelled)
			end
		end

		task.spawn(function() -- line: 507
			-- upvalues: sessionId (ref), hydrateKnownSession (copy), universeId (ref), v63 (copy), v62 (copy), u137 (ref), v138 (copy), v57 (copy), placeId (ref)
			if sessionId ~= nil and sessionId ~= "" then
				hydrateKnownSession(sessionId)

				return
			end

			if universeId == nil or universeId == 0 or v63.hasLoadedHistory() and #v63.getMergedHistory(false) > 0 then
				return
			end

			local v199 = v62.sessionFindByUniverse({
				sort = "desc",
				universeId = universeId
			})

			while v199.state(false).status == "pending" and (not u137 and (v138 == nil or (v138 == "" or v63.getCasSessionId() == v138))) do
				task.wait()
			end

			if u137 or v138 ~= nil and (v138 ~= "" and v63.getCasSessionId() ~= v138) or v199.state(false).status ~= "succeeded" then
				return
			end

			local result = v199.state(false).result
			local v201 = if result == nil then nil else result.sessions
			local v202 = if typeof(v201) ~= "table" then nil else v201[1]
			local v203 = if typeof(v202) ~= "table" then nil else v202.sessionId

			if typeof(v203) ~= "string" or v203 == "" then
				v63.markHistoryLoaded()

				return
			end

			v57({
				universeId = universeId,
				placeId = placeId,
				sessionId = v203
			})
		end)

		return function() -- line: 548
			-- upvalues: u137 (ref)
			u137 = true
		end
	end, {
		v63,
		sessionId,
		universeId,
		placeId,
		v62,
		v61
	})
	React.useEffect(function() -- line: 553
		-- upvalues: v63 (copy), sessionId (ref), v111 (copy), MessageBusService (copy), MessageId (copy), AppLifecycleObserverService (copy)
		if v63 == nil then
			return
		end

		local u142 = false

		local function refreshKnownSession() -- line: 558
			-- upvalues: v63 (copy), sessionId (ref), u142 (ref), v111 (copy)
			local v204 = v63.getCasSessionId()

			if (v204 == nil or v204 == "") and (sessionId ~= nil and sessionId ~= "") then
				v204 = sessionId
			end

			if v204 == nil or v204 == "" then
				return
			end

			task.spawn(function() -- line: 566
				-- upvalues: v63 (copy), u142 (ref), v111 (copy)
				if v63.refreshSession(function() -- line: 567
					-- upvalues: u142 (ref)
					return u142
				end) and not u142 then
					v111.current(function() -- line: 570
						-- upvalues: u142 (ref)
						return u142
					end)
				end
			end)
		end

		local v144 = MessageBusService:Subscribe(MessageId, function(_) -- line: 577
			-- upvalues: refreshKnownSession (copy)
			refreshKnownSession()
		end, false, true)
		local connection = AppLifecycleObserverService.OnUnhide:Connect(refreshKnownSession)

		return function() -- line: 582
			-- upvalues: u142 (ref), v144 (copy), connection (copy)
			u142 = true
			v144:Disconnect()
			connection:Disconnect()
		end
	end, {
		v63,
		sessionId
	})

	local v112 = React.useCallback(function(s4: string) -- line: 589
		-- upvalues: v103 (copy), v100 (copy), v102 (copy)
		v103.current = s4
		v100(s4)
		v102(nil)
	end, {
		v100,
		v102
	})
	local u113 = nil

	if FFlagBuildExperienceToolResultFailureRecovery then
		u113 = React.useCallback(function(n4: number) -- line: 597
			-- upvalues: v78 (copy), v77 (copy), v63 (copy), sessionId (ref), v103 (copy), v112 (copy), v102 (copy), creatorAgentChat (copy)
			return function(s5: string?, n5: number?) -- line: 598
				-- upvalues: v78 (copy), n4 (copy), v77 (copy), v63 (copy), sessionId (ref), v103 (copy), v112 (copy), v102 (copy), creatorAgentChat (copy)
				if v78.current == n4 then
					local current3 = v77.current
					local v209 = v63
					local v210 = sessionId

					if current3 ~= nil and (v209 == current3.session and (v210 == nil or (v210 == "" or (v210 == current3.sessionId or current3.sessionId == nil and v210 == current3.session.getCasSessionId())))) then
						if s5 ~= nil and v103.current == "" then
							v112(s5)
						end

						v102(creatorAgentChat.getToolResultFailureComposerError(n5))

						return
					end
				end
			end
		end, {
			v63,
			sessionId,
			v112,
			v102
		})
	end

	local v114 = React.useCallback(function(n6: number, p13, s6: string?, p14) -- line: 614
		-- upvalues: v78 (copy), v80 (copy), v79 (copy), v69 (copy), t5 (copy), v107 (copy), v112 (copy), v102 (copy), creatorAgentChat (copy), v106 (copy), sessionId (ref), v55 (copy)
		if n6 ~= v78.current then
			return
		end

		v80(nil)
		v79.current = nil
		v69(nil)

		if p13 ~= nil then
			if t5.onPromptFailure ~= nil then
				t5.onPromptFailure(p13.errorCode, p13.outOfCreditsReason)
			end

			if p14.placeId ~= nil then
				v107(p14.placeId, "Idle")
			end

			if s6 ~= nil then
				v112(s6)
				v102(creatorAgentChat.getPromptFailureComposerError(p13))
			end

			task.spawn(function() -- line: 641
				-- upvalues: p14 (copy), v78 (copy), n6 (copy)
				p14.refreshSession(function() -- line: 642
					-- upvalues: v78 (copy), n6 (copy)
					return v78.current ~= n6
				end)
			end)

			return
		end

		if p14.placeId ~= nil then
			v107(p14.placeId, "Completed")
		end

		v106.scrollToBottomAfterSend()

		local v152 = p14.getCasSessionId()

		if v152 ~= nil and v152 ~= "" then
			if t5.createUniverseOnFirstPrompt and sessionId == nil and p14.universeId ~= nil then
				local t6 = {
					universeId = p14.universeId,
					placeId = p14.placeId,
					sessionId = v152
				}

				v55(t6)

				if t5.onProjectResolved ~= nil then
					t5.onProjectResolved(t6)
				end
			end

			task.spawn(function() -- line: 670
				-- upvalues: p14 (copy), v78 (copy), n6 (copy)
				p14.refreshSession(function() -- line: 671
					-- upvalues: v78 (copy), n6 (copy)
					return v78.current ~= n6
				end)
			end)
		end
	end, {
		t5.createUniverseOnFirstPrompt,
		t5.onPromptFailure,
		t5.onProjectResolved,
		sessionId,
		v107,
		v55,
		v106,
		v112,
		v102,
		v80,
		v69
	})
	local v115 = React.useRef(v61)

	React.useEffect(function() -- line: 694
		-- upvalues: v61 (copy), v115 (copy), v96 (copy), v83 (copy), v106 (copy)
		local v154 = v61 and not v115.current

		v115.current = v61

		if not v61 then
			return
		end

		if not v154 and not v96 and v83 == nil then
			return
		end

		v106.scrollToBottomUnconditionally()
		task.defer(v106.scrollToBottomUnconditionally)
		task.delay(0.15, v106.scrollToBottomUnconditionally)
	end, {
		v61,
		v96,
		v83,
		#messages,
		v106
	})
	React.useEffect(function() -- line: 720
		-- upvalues: v76 (copy), v77 (copy), v63 (copy), sessionId (ref), v73 (copy), v78 (copy), v79 (copy), placeId (ref), v107 (copy), creatorAgentChat (copy), v114 (copy), FFlagBuildExperienceToolResultFailureRecovery (copy), u113 (ref), v80 (copy), v106 (copy), v91 (copy), v83 (copy), v62 (copy), v96 (copy)
		if v76.current ~= nil then
			local current4 = v77.current
			local v156 = v63
			local v157 = sessionId

			if current4 ~= nil and (v156 == current4.session and (v157 == nil or (v157 == "" or (v157 == current4.sessionId or current4.sessionId == nil and v157 == current4.session.getCasSessionId())))) then
				return
			end
		end

		if v73 ~= nil then
			return
		end

		if v63 == nil then
			return
		end

		local v158 = v63
		local v159 = v158.getCasSessionId()

		if typeof(v159) == "string" and v159 ~= "" then
		else
			local universeId2 = v158.universeId
			local placeId2 = v158.placeId

			v159 = if universeId2 == nil or placeId2 == nil then nil else `{ universeId2 }:{ placeId2 }`
		end

		if v159 == nil then
			return
		end

		local function attachResumedTurn(p15, n7: number?) -- line: 742
			-- upvalues: v78 (copy), v79 (copy), placeId (ref), v107 (copy), creatorAgentChat (copy), v63 (copy), v114 (copy), FFlagBuildExperienceToolResultFailureRecovery (copy), u113 (ref), v80 (copy), v106 (copy)
			local v213 = v78

			v213.current = v213.current + 1

			local current5 = v78.current

			v79.current = n7

			if placeId ~= nil then
				v107(placeId, "Loading")
			end

			local v215 = creatorAgentChat.createResumedAssistantTurn(v63, p15, function(p16) -- line: 752
				-- upvalues: v114 (copy), current5 (copy), v63 (copy)
				v114(current5, p16, nil, v63)
			end, if n7 == nil then nil else n7 - 1, if not FFlagBuildExperienceToolResultFailureRecovery then nil else u113(current5))

			v80(v215, v63)
			v215.start()
			v106.scrollToBottomUnconditionally()
		end

		if v91.activeTurnState ~= nil and v91.activeTurnItemIndex ~= nil and not v91.activeTurnState.isDone then
			local activeTurnStartSequenceId = v91.activeTurnStartSequenceId

			if activeTurnStartSequenceId == v79.current and v83 ~= nil then
				return
			end

			local v164 = v62.resumeTurnFromHistory(v159, v91.activeTurnState, v91.activeTurnSequenceIds)

			if v164 ~= nil then
				attachResumedTurn(v164, activeTurnStartSequenceId)
			end

			return
		end

		v79.current = nil

		local v165 = v62.getActiveTurnHandle(v159)
		local v166 = if v165 == nil then nil else v165.state(false)
		local v167 = v165 ~= nil and (v166 ~= nil and not v166.isDone)

		if not v96 and not v167 then
			return
		end

		if v167 then
			attachResumedTurn(v165, nil)
		end
	end, {
		v91,
		v63,
		sessionId,
		v62,
		v96,
		v83,
		placeId,
		v107,
		v114,
		v106,
		v80,
		v73,
		u113
	})

	local v116 = React.useCallback(function(p17, s7: string, n8: number, n9: number?) -- line: 818
		-- upvalues: v69 (copy), creatorAgentChat (copy), v114 (copy), FFlagBuildExperienceToolResultFailureRecovery (copy), u113 (ref), v107 (copy), v80 (copy), v106 (copy)
		v69({
			text = s7,
			afterSequenceId = n9
		})

		local v172 = creatorAgentChat.createLiveAssistantTurn(p17, s7, function(p18) -- line: 825
			-- upvalues: v114 (copy), n8 (copy), s7 (copy), p17 (copy)
			v114(n8, p18, s7, p17)
		end, if not FFlagBuildExperienceToolResultFailureRecovery then nil else u113(n8))

		if p17.placeId ~= nil then
			v107(p17.placeId, "Loading")
		end

		v80(v172, p17)
		v106.scrollToBottomAfterSend()
		v172.start()
	end, {
		v114,
		v107,
		v106,
		v80,
		v69,
		u113
	})
	local v117 = React.useCallback(function(s8: string, n10: number, n11: number?) -- line: 851
		-- upvalues: v69 (copy), UniverseCreate (copy), getDefaultTemplatePlaceId (copy), debug (copy), v78 (copy), UniverseConfiguration (copy), v55 (copy), t5 (copy), v62 (copy), sessionId (ref), v116 (copy), v80 (copy), v112 (copy), v102 (copy), CHAT_CREATE_UNIVERSE_ERROR (copy)
		v69({
			text = s8,
			afterSequenceId = n11
		})

		local elapsed = os.clock()

		UniverseCreate.getUniverseCreateStore().createUniverse({
			isPublish = true,
			templatePlaceId = getDefaultTemplatePlaceId()
		}):andThen(function(p19) -- line: 859
			-- upvalues: debug (copy), elapsed (copy), v78 (copy), n10 (copy), UniverseConfiguration (copy), v55 (copy), t5 (copy), v62 (copy), sessionId (ref), v116 (copy), s8 (copy), n11 (copy)
			debug.log("info", "build_experience create_universe succeeded", {
				durationMs = math.floor((os.clock() - elapsed) * 1000 + 0.5),
				universeId = p19.universeId,
				rootPlaceId = p19.rootPlaceId
			})

			if v78.current ~= n10 then
				return nil
			end

			local v218 = UniverseConfiguration.getUniverseConfigurationStore()

			return v218.patchConfiguration(p19.universeId, {
				audiences = { 1 }
			}):andThen(function() -- line: 874
				-- upvalues: v218 (copy), p19 (copy)
				return v218.setTeamCreate(p19.universeId, true)
			end):andThen(function() -- line: 877
				-- upvalues: v78 (copy), n10 (copy), p19 (copy), v55 (copy), t5 (copy), v62 (copy), sessionId (ref), v116 (copy), s8 (copy), n11 (copy)
				if v78.current ~= n10 then
					return nil
				end

				local t7 = {
					universeId = p19.universeId,
					placeId = p19.rootPlaceId
				}

				v55(t7)

				if t5.onProjectResolved ~= nil then
					t5.onProjectResolved(t7)
				end

				local v223 = v62.getSessionForProject(p19.universeId, p19.rootPlaceId, sessionId)

				v116(v223, s8, n10, n11)

				return nil
			end)
		end):catch(function(p20) -- line: 900
			-- upvalues: debug (copy), elapsed (copy), v78 (copy), n10 (copy), v80 (copy), v69 (copy), v112 (copy), s8 (copy), v102 (copy), CHAT_CREATE_UNIVERSE_ERROR (copy)
			debug.log("warn", "build_experience create_or_configure_universe failed", {
				durationMs = math.floor((os.clock() - elapsed) * 1000 + 0.5),
				error = p20
			})

			if v78.current ~= n10 then
				return
			end

			v80(nil)
			v69(nil)
			v112(s8)
			v102(CHAT_CREATE_UNIVERSE_ERROR)
		end)
	end, {
		sessionId,
		v62,
		t5.onProjectResolved,
		v80,
		v112,
		v102,
		v55,
		v69,
		v116
	})
	local v118 = React.useCallback(function() -- line: 928
		-- upvalues: v103 (copy), v112 (copy), v96 (copy), v77 (copy), v63 (copy), sessionId (ref), v76 (copy), v104 (copy), v106 (copy), t5 (copy), universeId (ref), v78 (copy), v71 (copy), v117 (copy), v91 (copy), v116 (copy)
		local current6 = v103.current
		local v178 = string.gsub(current6, "^%s*(.-)%s*$", "%1")

		if v178 == "" then
			v112("")

			return false
		end

		if v96 then
			local current7 = v77.current
			local v180 = v63
			local v181 = sessionId
			local v182 = if not (current7 ~= nil and (v180 == current7.session and (v181 == nil or (v181 == "" or (v181 == current7.sessionId or current7.sessionId == nil and v181 == current7.session.getCasSessionId()))))) then nil else v76.current

			if v182 ~= nil and v182.trySubmitComposerText(v178) then
				v112("")

				if v104.current then
					v104.current.releaseFocus()
				end

				v106.scrollToBottomAfterSend()

				return true
			end

			return false
		end

		local v183 = t5.createUniverseOnFirstPrompt == true and universeId == nil

		if not v183 and v63 == nil then
			return false
		end

		v106.captureStickToBottomForSend()

		local v184 = v78

		v184.current = v184.current + 1

		local current8 = v78.current

		v71(nil)
		v112("")

		if v104.current then
			v104.current.releaseFocus()
		end

		if v183 then
			v117(v178, current8, v91.latestSequenceId)
		else
			v116(v63, v178, current8, v91.latestSequenceId)
		end

		return true
	end, {
		v63,
		sessionId,
		universeId,
		v96,
		v106,
		v112,
		v117,
		v116,
		t5.createUniverseOnFirstPrompt,
		v71,
		v91
	})
	local v119 = React.useCallback(function() -- line: 985
		-- upvalues: v77 (copy), v63 (copy), sessionId (ref), v76 (copy), v78 (copy), v80 (copy), v79 (copy), v69 (copy), v71 (copy), v91 (copy), placeId (ref), v107 (copy)
		local current9 = v77.current
		local v187 = v63
		local v188 = sessionId
		local v189 = if not (current9 ~= nil and (v187 == current9.session and (v188 == nil or (v188 == "" or (v188 == current9.sessionId or current9.sessionId == nil and v188 == current9.session.getCasSessionId()))))) then nil else v76.current

		if v189 == nil then
			return
		end

		local v190 = v78

		v190.current = v190.current + 1
		v189.stop()
		v80(nil)
		v79.current = nil
		v69(nil)
		v71({
			session = v63,
			sessionId = v63.getCasSessionId(),
			startSequenceId = v91.activeTurnStartSequenceId
		})

		if placeId ~= nil then
			v107(placeId, "Idle")
		end
	end, {
		v63,
		sessionId,
		placeId,
		v107,
		v80,
		v69,
		v71,
		v91
	})
	local v120 = t5.autoFocusComposer == nil or t5.autoFocusComposer
	local v121 = if t5.focusComposerWhen ~= nil then t5.focusComposerWhen else v120

	React.useEffect(function() -- line: 1020
		-- upvalues: v120 (copy), v121 (copy), v104 (copy)
		if not v120 or not v121 then
			return function() -- line: 1022
			end
		end

		local u191 = false
		local v192 = v104

		local function v193() -- line: 1025
			-- upvalues: u191 (ref)
			return u191
		end

		local n12 = 8

		local function tryFocus() -- line: 169
			-- upvalues: v193 (copy), v192 (copy), n12 (ref), tryFocus (copy)
			if v193() then
				return
			end

			local current10 = v192.current

			if current10 then
				current10.focus()

				return
			end

			n12 -= 1

			if n12 > 0 then
				task.delay(0, tryFocus)
			end
		end

		task.defer(tryFocus)

		return function() -- line: 1028
			-- upvalues: u191 (ref)
			u191 = true
		end
	end, {
		v120,
		v121
	})

	local v122 = React.useCallback(function(s9: string) -- line: 1033
		-- upvalues: placeId (ref), launchPlaytestWithLoadingState (copy)
		if placeId == nil then
			return
		end

		launchPlaytestWithLoadingState(placeId, s9, true)
	end, { placeId })

	return {
		messages = messages,
		localToolActions = v88,
		composerText = v99,
		composerErrorText = v101,
		setComposerText = v112,
		isAssistantResponding = v96,
		canStopAssistantResponse = v83 ~= nil,
		canSendWhileResponding = v97,
		sendMessage = v118,
		stopAssistantResponse = v119,
		setScrollingFrame = v106.setScrollingFrame,
		textBoxRef = v104,
		clockBinding = v105,
		playtestPlaceId = placeId,
		launchPlaytest = if placeId == nil then nil else v122,
		hasPublishedTurn = includesPublishTool,
		subagentTaskState = subagentTaskState
	}
end

return useChatSessionCore
