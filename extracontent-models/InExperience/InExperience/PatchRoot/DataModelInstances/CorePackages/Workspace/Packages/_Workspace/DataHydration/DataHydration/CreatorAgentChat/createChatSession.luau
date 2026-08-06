local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local experimentOverride = require(script.Parent.experimentOverride)
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
	-- upvalues: sessionScalarState (copy), constants (copy), sessionHistoryCache (copy), sessionHistoryMerge (copy), Signals (copy), historyPageUtils (copy), historyLoader (copy), historyPolling (copy), AcpProtocol (copy), experimentOverride (copy), sendPrompt (copy)
	local t1 = {}
	local t2 = {}
	local v20 = sessionScalarState.createSessionScalarState(s1)
	local u21 = nil
	local v22 = p1.rpcTimeoutSeconds or constants.getRpcTimeoutSeconds()
	local v23 = sessionHistoryCache.createSessionHistoryCache()
	local n3 = 0

	local function buildMergedHistory() -- line: 49
		-- upvalues: sessionHistoryMerge (copy), t1 (ref), t2 (ref)
		return sessionHistoryMerge.orderMergedHistoryItems(t1, t2)
	end

	local v26, v27 = Signals.createSignal(buildMergedHistory())

	local function notifySessionStateChanged() -- line: 57
		-- upvalues: v27 (copy), buildMergedHistory (copy)
		v27(buildMergedHistory())
	end
	local function snapshotActiveSession() -- line: 72
		-- upvalues: v20 (copy), t1 (ref), t2 (ref)
		local v42 = v20.getCasSessionId(false)

		if v42 == nil or v42 == "" then
			return nil
		end

		return {
			loadedBySequenceId = t1,
			overlayBySequenceId = t2,
			hasLoadedHistory = v20.getHasLoadedHistory(false),
			nextHistoryPageToken = v20.getNextHistoryPageToken(false),
			latestObservedHistorySequenceId = v20.getLatestObservedHistorySequenceId(false)
		}
	end
	local function saveActiveSessionToCache() -- line: 86
		-- upvalues: v20 (copy), snapshotActiveSession (copy), v23 (copy)
		local v43 = v20.getCasSessionId(false)

		if v43 == nil or (v43 == "" or not v20.getHasLoadedHistory(false)) then
			return
		end

		local v44 = snapshotActiveSession()

		if v44 ~= nil then
			v23.save(v43, v44)
		end
	end
	local function restoreSessionFromCache(s2: string) -- line: 97
		-- upvalues: v23 (copy), t1 (ref), t2 (ref), v20 (copy), v27 (copy), buildMergedHistory (copy)
		local v46 = v23.restore(s2)

		if v46 == nil then
			return false
		end

		t1 = v46.loadedBySequenceId
		t2 = v46.overlayBySequenceId
		v20.setHasLoadedHistory(v46.hasLoadedHistory)
		v20.setNextHistoryPageToken(v46.nextHistoryPageToken)
		v20.setLatestObservedHistorySequenceId(v46.latestObservedHistorySequenceId)
		v27(buildMergedHistory())

		return true
	end
	local function clearActiveSessionState() -- line: 111
		-- upvalues: t1 (ref), t2 (ref), v20 (copy), v27 (copy), buildMergedHistory (copy)
		t1 = {}
		t2 = {}
		v20.setHasLoadedHistory(false)
		v20.setNextHistoryPageToken(nil)
		v20.setHistoryLoadInFlight(false)
		v20.setLatestObservedHistorySequenceId(nil)
		v27(buildMergedHistory())
	end
	local function setCasSessionIdInternal(s3: string) -- line: 121
		-- upvalues: v20 (copy), n3 (ref), snapshotActiveSession (copy), v23 (copy), t1 (ref), t2 (ref), v27 (copy), buildMergedHistory (copy), p1 (copy), clearActiveSessionState (copy)
		if s3 == "" then
			return
		end

		if s3 == v20.getCasSessionId(false) then
			return
		end

		n3 += 1

		local v48 = v20.getCasSessionId(false)

		if v48 ~= nil and v48 ~= "" and v20.getHasLoadedHistory(false) then
			local v49 = snapshotActiveSession()

			if v49 ~= nil then
				v23.save(v48, v49)
			end
		end

		v20.setCasSessionId(s3)
		v20.setHistoryLoadInFlight(false)

		local v50 = v23.restore(s3)
		local v51

		if v50 == nil then
			v51 = false
		else
			t1 = v50.loadedBySequenceId
			t2 = v50.overlayBySequenceId
			v20.setHasLoadedHistory(v50.hasLoadedHistory)
			v20.setNextHistoryPageToken(v50.nextHistoryPageToken)
			v20.setLatestObservedHistorySequenceId(v50.latestObservedHistorySequenceId)
			v27(buildMergedHistory())
			v51 = true
		end

		if v51 then
			p1.onCasSessionIdChanged(s3)

			return
		end

		clearActiveSessionState()
		p1.onCasSessionIdChanged(s3)
	end
	local function mergeHistoryPage(t3: {[any]: any}, s4: string?) -- line: 140
		-- upvalues: sessionHistoryMerge (copy), t1 (ref), t2 (ref), v20 (copy), historyPageUtils (copy), v27 (copy), buildMergedHistory (copy)
		sessionHistoryMerge.mergeHistoryIntoMap(t1, t3, t2)
		v20.setNextHistoryPageToken(s4)
		v20.noteHistorySequenceId(historyPageUtils.getMaxHistorySequenceId(t3))
		v27(buildMergedHistory())
	end

	local v35 = historyLoader.createHistoryLoader({
		deps = p1,
		rpcTimeoutSeconds = v22,
		getCasSessionId = function() -- line: 157
			-- upvalues: v20 (copy)
			return v20.getCasSessionId(false)
		end,
		getHistoryLoadInFlight = function() -- line: 160
			-- upvalues: v20 (copy)
			return v20.getHistoryLoadInFlight(false)
		end,
		setHistoryLoadInFlight = v20.setHistoryLoadInFlight,
		getNextHistoryPageToken = function() -- line: 164
			-- upvalues: v20 (copy)
			return v20.getNextHistoryPageToken(false)
		end,
		setNextHistoryPageToken = v20.setNextHistoryPageToken,
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
			-- upvalues: v20 (copy), historyPageUtils (copy)
			v20.noteHistorySequenceId(historyPageUtils.getMaxHistorySequenceId(t6))
		end,
		notifyMergedHistoryChanged = notifySessionStateChanged,
		markHistoryLoaded = v20.markHistoryLoaded,
		getRefreshGeneration = function() -- line: 185
			-- upvalues: n3 (ref)
			return n3
		end
	})
	local v36 = historyPolling.createHistoryPolling({
		deps = p1,
		rpcTimeoutSeconds = v22,
		getCasSessionId = function() -- line: 193
			-- upvalues: v20 (copy)
			return v20.getCasSessionId(false)
		end,
		getNextHistoryPageToken = function() -- line: 196
			-- upvalues: v20 (copy)
			return v20.getNextHistoryPageToken(false)
		end,
		mergeHistoryPage = mergeHistoryPage
	})

	local function ensureInitialized() -- line: 202
		-- upvalues: v20 (copy), p1 (copy), AcpProtocol (copy), historyPageUtils (copy), v22 (copy)
		if v20.getInitialized(false) then
			return true, nil
		end

		local v58 = p1.initialize({
			protocolVersion = AcpProtocol.ProtocolVersion
		})
		local v59 = historyPageUtils.awaitRequestState(v58.state, os.clock() + v22)

		if v59.status ~= "succeeded" then
			return false, v59.errorCode
		end

		v20.setInitialized(true)

		return true, nil
	end

	local v38 = sendPrompt.createSendPrompt({
		ensureInitialized = ensureInitialized,
		ensureCasSession = function() -- line: 215
			-- upvalues: v20 (copy), n1 (copy), n2 (copy), ensureInitialized (copy), p1 (copy), experimentOverride (copy), historyPageUtils (copy), v22 (copy), setCasSessionIdInternal (copy)
			local v60 = v20.getCasSessionId(false)

			if v60 ~= nil then
				return v60, nil
			end

			if n1 == nil or n2 == nil then
				return nil, {
					stage = "missing_project"
				}
			end

			local v61, v62 = ensureInitialized()

			if not v61 then
				return nil, {
					stage = "initialize",
					errorCode = v62
				}
			end

			local v63 = p1.sessionNew({
				project = {
					universeId = n1,
					placeId = n2
				},
				experiment = experimentOverride.getExperiment()
			})
			local v64 = historyPageUtils.awaitRequestState(v63.state, os.clock() + v22)

			if v64.status ~= "succeeded" then
				return nil, {
					stage = "session_new",
					errorCode = v64.errorCode
				}
			end

			local result = v64.result
			local v66 = if typeof(result) ~= "table" then nil else result.sessionId

			if typeof(v66) ~= "string" or v66 == "" then
				return nil, {
					stage = "session_new"
				}
			end

			setCasSessionIdInternal(v66)

			return v66, nil
		end,
		getLatestObservedHistorySequenceId = function() -- line: 247
			-- upvalues: v20 (copy)
			return v20.getLatestObservedHistorySequenceId(false)
		end,
		noteTurnSequenceIds = function(p2) -- line: 65
			-- upvalues: v20 (copy)
			local getLatestProcessedSequenceNumber = p2.getLatestProcessedSequenceNumber

			if getLatestProcessedSequenceNumber ~= nil then
				v20.noteHistorySequenceId(getLatestProcessedSequenceNumber())
			end
		end,
		startPollingTurnFromHistory = v36.startPollingTurnFromHistory,
		getAssistantTurnSequence = function() -- line: 252
			-- upvalues: v20 (copy)
			return v20.getAssistantTurnSequence(false)
		end,
		incrementAssistantTurnSequence = v20.incrementAssistantTurnSequence,
		sessionPrompt = p1.sessionPrompt,
		setActiveStop = function(p3: ((...any) -> ...any)?) -- line: 257
			-- upvalues: u21 (ref)
			u21 = p3
		end
	})

	return {
		universeId = n1,
		placeId = n2,
		getCasSessionId = function() -- line: 298
			-- upvalues: v20 (copy)
			return v20.getCasSessionId(false)
		end,
		setCasSessionId = setCasSessionIdInternal,
		hasLoadedHistory = function() -- line: 302
			-- upvalues: v20 (copy)
			return v20.getHasLoadedHistory(false)
		end,
		markHistoryLoaded = v20.markHistoryLoaded,
		getNextHistoryPageToken = function() -- line: 306
			-- upvalues: v20 (copy)
			return v20.getNextHistoryPageToken(false)
		end,
		getMergedHistory = v26,
		ingestRealtimeUpdate = function(p4, n4: number) -- line: 147
			-- upvalues: sessionHistoryMerge (copy), t2 (ref), t1 (ref), v20 (copy), v27 (copy), buildMergedHistory (copy)
			if sessionHistoryMerge.ingestOverlayUpdate(t2, t1, p4, n4) then
				v20.noteHistorySequenceId(n4)
				v27(buildMergedHistory())
			end
		end,
		mergeHistoryPage = mergeHistoryPage,
		refreshSession = v35.refreshSession,
		loadOlderHistory = v35.loadOlderHistory,
		sendPrompt = v38.sendPrompt,
		stopActiveTurn = function() -- line: 289
			-- upvalues: u21 (ref)
			if u21 ~= nil then
				u21()
			end
		end,
		submitActiveToolResult = function(t7: {[any]: any}, b1: boolean?, n5: number?, s5: string?) -- line: 270
			-- upvalues: v20 (copy), p1 (copy)
			local v73 = v20.getCasSessionId(false)

			if v73 == nil then
				return nil
			end

			return p1.submitToolResult({
				sessionId = v73,
				turnId = n5,
				referenceId = s5,
				content = t7,
				isError = b1 ~= nil and b1
			})
		end,
		getActiveTurnHandle = function() -- line: 262
			-- upvalues: v20 (copy), p1 (copy)
			local v68 = v20.getCasSessionId(false)

			if v68 == nil then
				return nil
			end

			return p1.getActiveTurnHandle(v68)
		end,
		startPollingActiveTurn = function(p5) -- line: 318
			-- upvalues: v20 (copy), v36 (copy)
			local v75 = v20.getCasSessionId(false)

			if v75 == nil then
				return function() -- line: 321
				end
			end

			return v36.startPollingActiveTurn(v75, p5)
		end
	}
end

return createChatSession
