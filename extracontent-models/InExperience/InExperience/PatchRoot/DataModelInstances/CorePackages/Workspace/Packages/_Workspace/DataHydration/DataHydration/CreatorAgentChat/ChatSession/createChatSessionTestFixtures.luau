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
local function makeTurnHandle(s2: string) -- line: 44
	-- upvalues: Signals (copy)
	local t1 = {
		requestId = nil,
		status = "queued",
		assistantText = "",
		pendingAgentMessageId = nil,
		pendingAgentMessageSequenceIndex = nil,
		thoughtText = "",
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
		thoughtMessages = {},
		thoughtMessageOrder = {},
		thoughtChunks = {},
		activitySlots = {},
		activityItems = {},
		toolCalls = {}
	}
	local v18, v19 = Signals.createSignal(t1)
	local u20 = false
	local t2 = {}
	local n1 = 0
	local u23 = nil
	local t3 = {
		state = v18,
		onNotification = function(p2) -- line: 76
			-- upvalues: n1 (ref), t2 (copy)
			n1 += 1

			local v44 = n1

			t2[v44] = p2

			return function() -- line: 80
				-- upvalues: t2 (copy), v44 (copy)
				t2[v44] = nil
			end
		end,
		getLatestProcessedSequenceNumber = function() -- line: 84
			-- upvalues: u23 (ref)
			return u23
		end,
		cancel = function() -- line: 87
			-- upvalues: u20 (ref), v18 (copy), v19 (copy)
			u20 = true

			local v45 = table.clone(v18(false))

			v45.status = "cancelled"
			v45.isDone = true
			v19(v45)
		end
	}

	local function finish(p3) -- line: 96
		-- upvalues: v18 (copy), v19 (copy)
		if p3 ~= nil then
		else
			p3 = table.clone(v18(false))
			p3.status = "succeeded"
			p3.isDone = true
		end

		v19(p3)
	end

	function t3.wasCancelled() -- line: 108
		-- upvalues: u20 (ref)
		return u20
	end
	function t3.setLatestProcessedSequenceNumber(n2: number) -- line: 111
		-- upvalues: u23 (ref)
		u23 = n2
	end
	function t3.emitNotification() -- line: 114
		-- upvalues: t2 (copy)
		for _, v49 in t2 do
			v49()
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
	makeTurnHandle = makeTurnHandle,
	defaultDeps = function() -- line: 122
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
				initialize = function(_) -- line: 147
					-- upvalues: t4 (copy), makeRequestHandle (copy)
					table.insert(t4, #t4 + 1)

					local t13 = {
						protocolVersion = 2
					}
					local v52, v53 = makeRequestHandle()

					v53(t13)

					return v52
				end,
				sessionNew = function(p6) -- line: 151
					-- upvalues: t5 (copy), makeRequestHandle (copy)
					table.insert(t5, p6)

					local t14 = {
						sessionId = "cas-session-1"
					}
					local v56, v57 = makeRequestHandle()

					v57(t14)

					return v56
				end,
				sessionLoad = function(p7, p8) -- line: 155
					-- upvalues: t6 (copy), t7 (copy), makeRequestHandle (copy)
					table.insert(t6, {
						sessionId = p7,
						params = p8
					})

					local v60 = t7[#t6] or {}

					if v60.history ~= nil or v60.nextHistoryPageToken ~= nil then
						local v61, v62 = makeRequestHandle()

						v62(v60)

						return v61
					end

					local t15 = {
						history = v60
					}
					local v64, v65 = makeRequestHandle()

					v65(t15)

					return v64
				end,
				sessionPrompt = function(p9) -- line: 163
					-- upvalues: t8 (copy), makeTurnHandle (copy), t11 (copy), t12 (copy)
					table.insert(t8, p9)

					local v67, v68 = makeTurnHandle(p9.sessionId)

					table.insert(t11, v67)
					table.insert(t12, v68)

					return v67
				end,
				ingestSessionHistory = function(p10, p11, p12) -- line: 170
					-- upvalues: t9 (copy), t10 (copy)
					table.insert(t9, {
						sessionId = p10,
						history = p11,
						afterSequenceId = p12
					})

					local v72 = t10[#t9]

					if v72 ~= nil then
						return v72
					end

					return #p11 > 0
				end,
				submitToolResult = function(_) -- line: 179
					-- upvalues: makeRequestHandle (copy)
					local v74, v75 = makeRequestHandle()

					v75(nil)

					return v74
				end,
				getActiveTurnHandle = function(_) -- line: 182
					-- upvalues: t11 (copy)
					return t11[#t11]
				end,
				onCasSessionIdChanged = function(_) -- line: 185
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
			finishLastTurn = function(p16) -- line: 199
				-- upvalues: t12 (copy)
				local v79 = t12[#t12]

				if v79 ~= nil then
					v79(p16)
				end
			end
		}
	end,
	awaitTurnHandle = function(p17, n3: number?) -- line: 208
		local v37 = os.clock() + (n3 or 3)

		while p17.getTurnHandle(false) == nil and p17.getSetupError(false) == nil and not (v37 < os.clock()) do
			task.wait()
		end
	end,
	waitFor = function(p18: ((...any) -> ...any), n4: number?) -- line: 218
		local v40 = os.clock() + (n4 or 3)

		while not p18() and not (v40 < os.clock()) do
			task.wait()
		end
	end
}
