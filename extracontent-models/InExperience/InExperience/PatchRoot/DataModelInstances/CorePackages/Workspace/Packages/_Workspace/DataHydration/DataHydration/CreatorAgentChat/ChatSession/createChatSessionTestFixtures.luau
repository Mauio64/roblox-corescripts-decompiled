local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)

local function makeRequestHandle() -- line: 16
	-- upvalues: Signals (copy)
	local v5, v6 = Signals.createSignal({
		status = "pending"
	})

	local function succeed(p1) -- line: 18
		-- upvalues: v6 (copy)
		v6({
			status = "succeeded",
			result = p1
		})
	end
	local function fail(s1: string) -- line: 21
		-- upvalues: v6 (copy)
		v6({
			status = "failed",
			error = s1
		})
	end

	return {
		state = v5,
		dispose = function() -- line: 26
		end
	}, succeed, fail
end
local function makeTurnHandle(s2: string) -- line: 53
	-- upvalues: Signals (copy)
	local t1 = {
		requestId = nil,
		status = "queued",
		assistantText = "",
		pendingAgentMessageId = nil,
		pendingAgentMessageSequenceIndex = nil,
		toolCallCount = 0,
		infoUpdate = nil,
		stopReason = nil,
		error = nil,
		errorCode = nil,
		isDone = false,
		sessionId = s2,
		assistantMessages = {},
		assistantMessageOrder = {},
		pendingAgentMessageContent = {},
		activitySlots = {},
		activityItems = {},
		toolCalls = {}
	}
	local v20, v21 = Signals.createSignal(t1)
	local u22 = false
	local t2 = {}
	local n1 = 0
	local u25 = nil
	local t3 = {
		state = v20,
		onNotification = function(p2) -- line: 81
			-- upvalues: n1 (ref), t2 (copy)
			n1 += 1

			local v46 = n1

			t2[v46] = p2

			return function() -- line: 85
				-- upvalues: t2 (copy), v46 (copy)
				t2[v46] = nil
			end
		end,
		getLatestProcessedSequenceNumber = function() -- line: 89
			-- upvalues: u25 (ref)
			return u25
		end,
		cancel = function() -- line: 92
			-- upvalues: u22 (ref), v20 (copy), v21 (copy)
			u22 = true

			local v47 = table.clone(v20(false))

			v47.status = "cancelled"
			v47.isDone = true
			v21(v47)
		end
	}

	local function finish(p3) -- line: 101
		-- upvalues: v20 (copy), v21 (copy)
		if p3 ~= nil then
		else
			p3 = table.clone(v20(false))
			p3.status = "succeeded"
			p3.isDone = true
		end

		v21(p3)
	end

	function t3.wasCancelled() -- line: 113
		-- upvalues: u22 (ref)
		return u22
	end
	function t3.setLatestProcessedSequenceNumber(n2: number) -- line: 116
		-- upvalues: u25 (ref)
		u25 = n2
	end
	function t3.emitNotification() -- line: 119
		-- upvalues: t2 (copy)
		for _, v51 in t2 do
			v51()
		end
	end

	return t3, finish
end

return {
	Types = require(script.Parent.Parent.types),
	makeRequestHandle = makeRequestHandle,
	makeImmediateSuccess = function(p4) -- line: 31
		-- upvalues: makeRequestHandle (copy)
		local v10, v11 = makeRequestHandle()

		v11(p4)

		return v10
	end,
	makeImmediateFailure = function(s3: string) -- line: 37
		-- upvalues: makeRequestHandle (copy)
		local v13, _, v15 = makeRequestHandle()

		v15(s3)

		return v13
	end,
	makeImmediateFailureWithCode = function(s4: string, n3: number) -- line: 43
		-- upvalues: Signals (copy)
		return {
			state = Signals.createSignal({
				status = "failed",
				error = s4,
				errorCode = n3
			}),
			dispose = function() -- line: 48
			end
		}
	end,
	makeTurnHandle = makeTurnHandle,
	defaultDeps = function() -- line: 127
		-- upvalues: makeRequestHandle (copy), makeTurnHandle (copy)
		local t4 = {}
		local t5 = {}
		local t6 = {}
		local t7 = {}
		local t8 = {}
		local t9 = {}
		local t10 = {}
		local t11 = {}
		local t12 = {}

		return {
			deps = {
				rpcTimeoutSeconds = 5,
				initialize = function(_) -- line: 152
					-- upvalues: t4 (copy), makeRequestHandle (copy)
					table.insert(t4, #t4 + 1)

					local t13 = {
						protocolVersion = 2
					}
					local v54, v55 = makeRequestHandle()

					v55(t13)

					return v54
				end,
				sessionNew = function(p6) -- line: 156
					-- upvalues: t5 (copy), makeRequestHandle (copy)
					table.insert(t5, p6)

					local t14 = {
						sessionId = "cas-session-1"
					}
					local v58, v59 = makeRequestHandle()

					v59(t14)

					return v58
				end,
				sessionLoad = function(p7, p8) -- line: 160
					-- upvalues: t6 (copy), t7 (copy), makeRequestHandle (copy)
					table.insert(t6, {
						sessionId = p7,
						params = p8
					})

					local v62 = t7[#t6] or {}

					if v62.history ~= nil or v62.nextHistoryPageToken ~= nil then
						local v63, v64 = makeRequestHandle()

						v64(v62)

						return v63
					end

					local t15 = {
						history = v62
					}
					local v66, v67 = makeRequestHandle()

					v67(t15)

					return v66
				end,
				sessionPrompt = function(p9) -- line: 168
					-- upvalues: t8 (copy), makeTurnHandle (copy), t11 (copy), t12 (copy)
					table.insert(t8, p9)

					local v69, v70 = makeTurnHandle(p9.sessionId)

					table.insert(t11, v69)
					table.insert(t12, v70)

					return v69
				end,
				ingestSessionHistory = function(p10, p11, p12) -- line: 175
					-- upvalues: t9 (copy), t10 (copy)
					table.insert(t9, {
						sessionId = p10,
						history = p11,
						afterSequenceId = p12
					})

					local v74 = t10[#t9]

					if v74 ~= nil then
						return v74
					end

					return #p11 > 0
				end,
				submitToolResult = function(_) -- line: 184
					-- upvalues: makeRequestHandle (copy)
					local v76, v77 = makeRequestHandle()

					v77(nil)

					return v76
				end,
				getActiveTurnHandle = function(_) -- line: 187
					-- upvalues: t11 (copy)
					return t11[#t11]
				end,
				onCasSessionIdChanged = function(_) -- line: 190
				end
			},
			initializeCalls = t4,
			sessionNewCalls = t5,
			sessionLoadCalls = t6,
			sessionLoadResults = t7,
			sessionPromptCalls = t8,
			ingestSessionHistoryCalls = t9,
			ingestSessionHistoryResults = t10,
			turnHandles = t11,
			finishLastTurn = function(p16) -- line: 204
				-- upvalues: t12 (copy)
				local v81 = t12[#t12]

				if v81 ~= nil then
					v81(p16)
				end
			end
		}
	end,
	awaitTurnHandle = function(p17, n4: number?) -- line: 213
		local v39 = os.clock() + (n4 or 3)

		while p17.getTurnHandle(false) == nil and p17.getSetupError(false) == nil and not (v39 < os.clock()) do
			task.wait()
		end
	end,
	waitFor = function(p18: ((...any) -> ...any), n5: number?) -- line: 223
		local v42 = os.clock() + (n5 or 3)

		while not p18() and not (v42 < os.clock()) do
			task.wait()
		end
	end
}
