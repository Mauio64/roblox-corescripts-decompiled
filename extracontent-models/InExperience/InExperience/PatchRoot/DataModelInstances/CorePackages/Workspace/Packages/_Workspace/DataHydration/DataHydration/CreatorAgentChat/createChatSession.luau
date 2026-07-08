local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local sessionHistoryMerge = require(script.Parent.sessionHistoryMerge)

require(script.Parent.types)

local constants = require(script.Parent.ChatSession.constants)
local historyLoader = require(script.Parent.ChatSession.historyLoader)
local historyPageUtils = require(script.Parent.ChatSession.historyPageUtils)
local historyPolling = require(script.Parent.ChatSession.historyPolling)
local sendPrompt = require(script.Parent.ChatSession.sendPrompt)
local sessionHistoryCache = require(script.Parent.ChatSession.sessionHistoryCache)
local sessionScalarState = require(script.Parent.ChatSession.sessionScalarState)

require(script.Parent.ChatSession.sessionDeps)

local function createChatSession(p1, n1: number?, n2: number?, s1: string?) -- line: 34
	-- upvalues: sessionScalarState (copy), constants (copy), sessionHistoryCache (copy), sessionHistoryMerge (copy), Signals (copy), historyPageUtils (copy), historyLoader (copy), historyPolling (copy), AcpProtocol (copy), sendPrompt (copy)
	local t1 = {}
	local t2 = {}
	local v19 = sessionScalarState.createSessionScalarState(s1)
	local u20 = nil
	local v21 = p1.rpcTimeoutSeconds or constants.getRpcTimeoutSeconds()
	local v22 = sessionHistoryCache.createSessionHistoryCache()
	local n3 = 0

	local function buildMergedHistory() -- line: 49
		-- upvalues: sessionHistoryMerge (copy), t1 (ref), t2 (ref)
		return sessionHistoryMerge.orderMergedHistoryItems(t1, t2)
	end

	local v25, v26 = Signals.createSignal(buildMergedHistory())

	local function notifySessionStateChanged() -- line: 57
		-- upvalues: v26 (copy), buildMergedHistory (copy)
		v26(buildMergedHistory())
	end
	local function snapshotActiveSession() -- line: 72
		-- upvalues: v19 (copy), t1 (ref), t2 (ref)
		local v41 = v19.getCasSessionId(false)

		if v41 == nil or v41 == "" then
			return nil
		end

		return {
			loadedBySequenceId = t1,
			overlayBySequenceId = t2,
			hasLoadedHistory = v19.getHasLoadedHistory(false),
			nextHistoryPageToken = v19.getNextHistoryPageToken(false),
			latestObservedHistorySequenceId = v19.getLatestObservedHistorySequenceId(false)
		}
	end
	local function saveActiveSessionToCache() -- line: 86
		-- upvalues: v19 (copy), snapshotActiveSession (copy), v22 (copy)
		local v42 = v19.getCasSessionId(false)

		if v42 == nil or (v42 == "" or not v19.getHasLoadedHistory(false)) then
			return
		end

		local v43 = snapshotActiveSession()

		if v43 ~= nil then
			v22.save(v42, v43)
		end
	end
	local function restoreSessionFromCache(s2: string) -- line: 97
		-- upvalues: v22 (copy), t1 (ref), t2 (ref), v19 (copy), v26 (copy), buildMergedHistory (copy)
		local v45 = v22.restore(s2)

		if v45 == nil then
			return false
		end

		t1 = v45.loadedBySequenceId
		t2 = v45.overlayBySequenceId
		v19.setHasLoadedHistory(v45.hasLoadedHistory)
		v19.setNextHistoryPageToken(v45.nextHistoryPageToken)
		v19.setLatestObservedHistorySequenceId(v45.latestObservedHistorySequenceId)
		v26(buildMergedHistory())

		return true
	end
	local function clearActiveSessionState() -- line: 111
		-- upvalues: t1 (ref), t2 (ref), v19 (copy), v26 (copy), buildMergedHistory (copy)
		t1 = {}
		t2 = {}
		v19.setHasLoadedHistory(false)
		v19.setNextHistoryPageToken(nil)
		v19.setHistoryLoadInFlight(false)
		v19.setLatestObservedHistorySequenceId(nil)
		v26(buildMergedHistory())
	end
	local function setCasSessionIdInternal(s3: string) -- line: 121
		-- upvalues: v19 (copy), n3 (ref), snapshotActiveSession (copy), v22 (copy), t1 (ref), t2 (ref), v26 (copy), buildMergedHistory (copy), p1 (copy), clearActiveSessionState (copy)
		if s3 == "" then
			return
		end

		if s3 == v19.getCasSessionId(false) then
			return
		end

		n3 += 1

		local v47 = v19.getCasSessionId(false)

		if v47 ~= nil and v47 ~= "" and v19.getHasLoadedHistory(false) then
			local v48 = snapshotActiveSession()

			if v48 ~= nil then
				v22.save(v47, v48)
			end
		end

		v19.setCasSessionId(s3)
		v19.setHistoryLoadInFlight(false)

		local v49 = v22.restore(s3)
		local v50

		if v49 == nil then
			v50 = false
		else
			t1 = v49.loadedBySequenceId
			t2 = v49.overlayBySequenceId
			v19.setHasLoadedHistory(v49.hasLoadedHistory)
			v19.setNextHistoryPageToken(v49.nextHistoryPageToken)
			v19.setLatestObservedHistorySequenceId(v49.latestObservedHistorySequenceId)
			v26(buildMergedHistory())
			v50 = true
		end

		if v50 then
			p1.onCasSessionIdChanged(s3)

			return
		end

		clearActiveSessionState()
		p1.onCasSessionIdChanged(s3)
	end
	local function mergeHistoryPage(t3: {[any]: any}, s4: string?) -- line: 140
		-- upvalues: sessionHistoryMerge (copy), t1 (ref), t2 (ref), v19 (copy), historyPageUtils (copy), v26 (copy), buildMergedHistory (copy)
		sessionHistoryMerge.mergeHistoryIntoMap(t1, t3, t2)
		v19.setNextHistoryPageToken(s4)
		v19.noteHistorySequenceId(historyPageUtils.getMaxHistorySequenceId(t3))
		v26(buildMergedHistory())
	end

	local v34 = historyLoader.createHistoryLoader({
		deps = p1,
		rpcTimeoutSeconds = v21,
		getCasSessionId = function() -- line: 157
			-- upvalues: v19 (copy)
			return v19.getCasSessionId(false)
		end,
		getHistoryLoadInFlight = function() -- line: 160
			-- upvalues: v19 (copy)
			return v19.getHistoryLoadInFlight(false)
		end,
		setHistoryLoadInFlight = v19.setHistoryLoadInFlight,
		getNextHistoryPageToken = function() -- line: 164
			-- upvalues: v19 (copy)
			return v19.getNextHistoryPageToken(false)
		end,
		setNextHistoryPageToken = v19.setNextHistoryPageToken,
		getLoadedBySequenceId = function() -- line: 168
			-- upvalues: t1 (ref)
			return t1
		end,
		setLoadedBySequenceId = function(t4: {[any]: any}) -- line: 171
			-- upvalues: t1 (ref)
			t1 = t4
		end,
		getOverlayBySequenceId = function() -- line: 174
			-- upvalues: t2 (ref)
			return t2
		end,
		setOverlayBySequenceId = function(t5: {[any]: any}) -- line: 177
			-- upvalues: t2 (ref)
			t2 = t5
		end,
		buildMergedHistory = buildMergedHistory,
		mergeHistoryPage = mergeHistoryPage,
		noteHistorySequenceIds = function(t6: {[any]: any}) -- line: 61
			-- upvalues: v19 (copy), historyPageUtils (copy)
			v19.noteHistorySequenceId(historyPageUtils.getMaxHistorySequenceId(t6))
		end,
		notifyMergedHistoryChanged = notifySessionStateChanged,
		markHistoryLoaded = v19.markHistoryLoaded,
		getRefreshGeneration = function() -- line: 185
			-- upvalues: n3 (ref)
			return n3
		end
	})
	local v35 = historyPolling.createHistoryPolling({
		deps = p1,
		rpcTimeoutSeconds = v21,
		getNextHistoryPageToken = function() -- line: 193
			-- upvalues: v19 (copy)
			return v19.getNextHistoryPageToken(false)
		end,
		mergeHistoryPage = mergeHistoryPage
	})

	local function ensureInitialized() -- line: 199
		-- upvalues: v19 (copy), p1 (copy), AcpProtocol (copy), historyPageUtils (copy), v21 (copy)
		if v19.getInitialized(false) then
			return true
		end

		local v57 = p1.initialize({
			protocolVersion = AcpProtocol.ProtocolVersion
		})

		if historyPageUtils.awaitRequestState(v57.state, os.clock() + v21).status ~= "succeeded" then
			return false
		end

		v19.setInitialized(true)

		return true
	end

	local v37 = sendPrompt.createSendPrompt({
		ensureInitialized = ensureInitialized,
		ensureCasSession = function() -- line: 212
			-- upvalues: v19 (copy), n1 (copy), n2 (copy), ensureInitialized (copy), p1 (copy), historyPageUtils (copy), v21 (copy), setCasSessionIdInternal (copy)
			local v58 = v19.getCasSessionId(false)

			if v58 ~= nil then
				return v58, nil
			end

			if n1 == nil or n2 == nil then
				return nil, {
					stage = "missing_project"
				}
			end

			if not ensureInitialized() then
				return nil, {
					stage = "initialize"
				}
			end

			local v59 = p1.sessionNew({
				project = {
					universeId = n1,
					placeId = n2
				}
			})
			local v60 = historyPageUtils.awaitRequestState(v59.state, os.clock() + v21)

			if v60.status ~= "succeeded" then
				return nil, {
					stage = "session_new"
				}
			end

			local result = v60.result
			local v62 = if typeof(result) ~= "table" then nil else result.sessionId

			if typeof(v62) ~= "string" or v62 == "" then
				return nil, {
					stage = "session_new"
				}
			end

			setCasSessionIdInternal(v62)

			return v62, nil
		end,
		getLatestObservedHistorySequenceId = function() -- line: 242
			-- upvalues: v19 (copy)
			return v19.getLatestObservedHistorySequenceId(false)
		end,
		noteTurnSequenceIds = function(p2) -- line: 65
			-- upvalues: v19 (copy)
			local getLatestProcessedSequenceNumber = p2.getLatestProcessedSequenceNumber

			if getLatestProcessedSequenceNumber ~= nil then
				v19.noteHistorySequenceId(getLatestProcessedSequenceNumber())
			end
		end,
		startPollingTurnFromHistory = v35.startPollingTurnFromHistory,
		getAssistantTurnSequence = function() -- line: 247
			-- upvalues: v19 (copy)
			return v19.getAssistantTurnSequence(false)
		end,
		incrementAssistantTurnSequence = v19.incrementAssistantTurnSequence,
		sessionPrompt = p1.sessionPrompt,
		setActiveStop = function(p3: ((...any) -> ...any)?) -- line: 252
			-- upvalues: u20 (ref)
			u20 = p3
		end
	})

	return {
		universeId = n1,
		placeId = n2,
		getCasSessionId = function() -- line: 293
			-- upvalues: v19 (copy)
			return v19.getCasSessionId(false)
		end,
		setCasSessionId = setCasSessionIdInternal,
		hasLoadedHistory = function() -- line: 297
			-- upvalues: v19 (copy)
			return v19.getHasLoadedHistory(false)
		end,
		markHistoryLoaded = v19.markHistoryLoaded,
		getNextHistoryPageToken = function() -- line: 301
			-- upvalues: v19 (copy)
			return v19.getNextHistoryPageToken(false)
		end,
		getMergedHistory = v25,
		ingestRealtimeUpdate = function(p4, n4: number) -- line: 147
			-- upvalues: sessionHistoryMerge (copy), t2 (ref), t1 (ref), v19 (copy), v26 (copy), buildMergedHistory (copy)
			if sessionHistoryMerge.ingestOverlayUpdate(t2, t1, p4, n4) then
				v19.noteHistorySequenceId(n4)
				v26(buildMergedHistory())
			end
		end,
		mergeHistoryPage = mergeHistoryPage,
		refreshSession = v34.refreshSession,
		loadOlderHistory = v34.loadOlderHistory,
		sendPrompt = v37.sendPrompt,
		stopActiveTurn = function() -- line: 284
			-- upvalues: u20 (ref)
			if u20 ~= nil then
				u20()
			end
		end,
		submitActiveToolResult = function(t7: {[any]: any}, b1: boolean?, n5: number?, s5: string?) -- line: 265
			-- upvalues: v19 (copy), p1 (copy)
			local v69 = v19.getCasSessionId(false)

			if v69 == nil then
				return nil
			end

			return p1.submitToolResult({
				sessionId = v69,
				turnId = n5,
				referenceId = s5,
				content = t7,
				isError = b1 ~= nil and b1
			})
		end,
		getActiveTurnHandle = function() -- line: 257
			-- upvalues: v19 (copy), p1 (copy)
			local v64 = v19.getCasSessionId(false)

			if v64 == nil then
				return nil
			end

			return p1.getActiveTurnHandle(v64)
		end,
		startPollingActiveTurn = function(p5) -- line: 313
			-- upvalues: v19 (copy), v35 (copy)
			local v71 = v19.getCasSessionId(false)

			if v71 == nil then
				return function() -- line: 316
				end
			end

			return v35.startPollingActiveTurn(v71, p5)
		end
	}
end

return createChatSession
