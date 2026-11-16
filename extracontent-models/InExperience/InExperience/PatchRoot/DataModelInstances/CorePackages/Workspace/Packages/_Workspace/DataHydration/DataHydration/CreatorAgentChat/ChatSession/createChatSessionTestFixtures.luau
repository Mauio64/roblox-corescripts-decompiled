local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local function makeRequestHandle()
	local signal, v = Signals.createSignal({ status = "pending" })
	local function succeed(p)
		v({ status = "succeeded", result = p })
	end
	local function fail(err: string)
		v({ status = "failed", error = err })
	end
	return {
		state = signal,
		dispose = function() end
	}, succeed, fail
end

local function makeImmediateSuccess(p) -- 5 equivalent calls inferred from this helper
	local requestHandle, v = makeRequestHandle()
	v(p)
	return requestHandle
end

local function makeTurnHandle(sessionId: string)
	local signal, v = Signals.createSignal({
		sessionId = sessionId,
		requestId = nil,
		status = "queued",
		assistantText = "",
		assistantMessages = {},
		assistantMessageOrder = {},
		pendingAgentMessageId = nil,
		pendingAgentMessageContent = {},
		pendingAgentMessageSequenceIndex = nil,
		activitySlots = {},
		activityItems = {},
		toolCalls = {},
		toolCallCount = 0,
		infoUpdate = nil,
		stopReason = nil,
		error = nil,
		errorCode = nil,
		isDone = false
	})
	local signal2, v2 = Signals.createSignal(false)
	local v3 = false
	local turnId = nil
	local v4 = {}
	local count = 0
	local set = {}
	local latestProcessedSequenceNumber = nil
	local v5 = nil
	local v6 = 0

	local function noteProcessedSequenceNumber(p: number) -- 1 equivalent call inferred from this helper
		if set[p] == true then
			return
		end

		set[p] = true

		if latestProcessedSequenceNumber == nil then
			latestProcessedSequenceNumber = p
			v5 = p
		elseif latestProcessedSequenceNumber < p then
			v6 += p - latestProcessedSequenceNumber - 1
			latestProcessedSequenceNumber = p
		elseif p < v5 then
			v6 += v5 - p - 1
			v5 = p
		else
			v6 -= 1
		end
	end

	local v7 = {
		state = signal,
		getTurnId = function()
			return turnId
		end,
		onNotification = function(p)
			count += 1
			local v7 = count
			v4[v7] = p
			return function()
				v4[v7] = nil
			end
		end,
		getLatestProcessedSequenceNumber = function()
			return latestProcessedSequenceNumber
		end,
		hasSequenceGap = function(): boolean
			return v6 > 0
		end,
		noteProcessedSequenceNumber = noteProcessedSequenceNumber,
		isAccepted = signal2,
		cancel = function()
			v3 = true
			local clone = table.clone(signal(false))
			clone.status = "cancelled"
			clone.isDone = true
			v(clone)
		end
	}

	local function finish(p)
		if p == nil then
			p = table.clone(signal(false))
			p.status = "succeeded"
			p.isDone = true
		end

		v(p)
	end

	function v7.wasCancelled()
		return v3
	end

	function v7.setTurnId(p: number?)
		turnId = p
	end
	function v7.setLatestProcessedSequenceNumber(p: number)
		noteProcessedSequenceNumber(p) -- inferred equivalent call
	end
	function v7.emitNotification()
		for _, v8 in v4 do
			v8()
		end
	end
	function v7.markStreaming()
		local clone = table.clone(signal(false))
		clone.status = "streaming"
		v(clone)
	end
	function v7.markAccepted()
		v2(true)
	end
	function v7.fail()
		local clone = table.clone(signal(false))
		clone.status = "failed"
		clone.isDone = true
		v(clone)
	end
	return v7, finish
end

local CreateChatSessionTestFixtures = {}
CreateChatSessionTestFixtures.Types = require(script.Parent.Parent.types)
CreateChatSessionTestFixtures.makeRequestHandle = makeRequestHandle
CreateChatSessionTestFixtures.makeImmediateSuccess = makeImmediateSuccess

function CreateChatSessionTestFixtures.makeImmediateFailure(p: string)
	local requestHandle, _, v = makeRequestHandle()
	v(p)
	return requestHandle
end

function CreateChatSessionTestFixtures.makeImmediateFailureWithCode(err: string, errorCode: number)
	return {
		state = Signals.createSignal({ status = "failed", error = err, errorCode = errorCode }),
		dispose = function() end
	}
end

CreateChatSessionTestFixtures.makeTurnHandle = makeTurnHandle

function CreateChatSessionTestFixtures.defaultDeps()
	local initializeCalls = {}
	local sessionNewCalls = {}
	local sessionLoadCalls = {}
	local sessionLoadResults = {}
	local sessionPromptCalls = {}
	local ingestSessionHistoryCalls = {}
	local ingestSessionHistoryResults = {}
	local sequenceIdSet = {}
	local turnHandles = {}
	local v = {}

	return {
		deps = {
			initialize = function(_)
				table.insert(initializeCalls, #initializeCalls + 1)
				return makeImmediateSuccess({ protocolVersion = 2 }) -- inferred equivalent call
			end,
			sessionNew = function(p)
				table.insert(sessionNewCalls, p)
				return makeImmediateSuccess({ sessionId = "cas-session-1" }) -- inferred equivalent call
			end,
			sessionLoad = function(sessionId, params)
				table.insert(sessionLoadCalls, { sessionId = sessionId, params = params })
				local history = sessionLoadResults[#sessionLoadCalls] or {}

				if history.history == nil and history.nextHistoryPageToken == nil then
					return makeImmediateSuccess({ history = history }) -- inferred equivalent call
				end

				return makeImmediateSuccess(history) -- inferred equivalent call
			end,
			sessionPrompt = function(p)
				table.insert(sessionPromptCalls, p)
				local turnHandle, finish = makeTurnHandle(p.sessionId)
				table.insert(turnHandles, turnHandle)
				table.insert(v, finish)
				return turnHandle
			end,
			ingestSessionHistory = function(sessionId, history, afterSequenceId)
				table.insert(ingestSessionHistoryCalls, {
					sessionId = sessionId,
					history = history,
					afterSequenceId = afterSequenceId
				})

				local v2 = ingestSessionHistoryResults[#ingestSessionHistoryCalls]

				if v2 ~= nil then
					return v2
				end

				local sequenceIds = {}

				for _, item in history do
					local sequenceId = item.sequenceId

					if not (typeof(sequenceId) == "number" and (afterSequenceId == nil or afterSequenceId < sequenceId)) then
						continue
					end

					if sequenceIdSet[sequenceId] ~= true then
						sequenceIdSet[sequenceId] = true
						table.insert(sequenceIds, sequenceId)
					end

					local v3 = turnHandles[#turnHandles]

					if v3 ~= nil and v3.noteProcessedSequenceNumber ~= nil then
						v3.noteProcessedSequenceNumber(sequenceId)
					end
				end

				return sequenceIds
			end,
			submitToolResult = function(_)
				return makeImmediateSuccess(nil) -- inferred equivalent call
			end,
			getActiveTurnHandle = function(_)
				return turnHandles[#turnHandles]
			end,
			onCasSessionIdChanged = function(_) end,
			rpcTimeoutSeconds = 5
		},
		initializeCalls = initializeCalls,
		sessionNewCalls = sessionNewCalls,
		sessionLoadCalls = sessionLoadCalls,
		sessionLoadResults = sessionLoadResults,
		sessionPromptCalls = sessionPromptCalls,
		ingestSessionHistoryCalls = ingestSessionHistoryCalls,
		ingestSessionHistoryResults = ingestSessionHistoryResults,
		turnHandles = turnHandles,
		finishLastTurn = function(p)
			local v2 = v[#v]

			if v2 ~= nil then
				v2(p)
			end
		end
	}
end

function CreateChatSessionTestFixtures.awaitTurnHandle(p, value: number?)
	local v = os.clock() + (value or 3)

	while p.getTurnHandle(false) == nil and p.getSetupError(false) == nil and not (v < os.clock()) do
		task.wait()
	end
end

function CreateChatSessionTestFixtures.waitFor(callback, value: number?)
	local v = os.clock() + (value or 3)

	while not (callback() or v < os.clock()) do
		task.wait()
	end
end

return CreateChatSessionTestFixtures
