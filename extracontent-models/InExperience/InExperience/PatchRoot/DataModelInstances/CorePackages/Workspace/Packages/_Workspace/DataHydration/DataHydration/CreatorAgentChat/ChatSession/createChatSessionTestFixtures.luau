local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)

local function makeRequestHandle() -- line: 14
	-- upvalues: Signals (copy)
	local v5, v6 = Signals.createSignal({
		status = "pending"
	})

	local function succeed(p1) -- line: 16
		-- upvalues: v6 (copy)
		v6({
			status = "succeeded",
			result = p1
		})
	end
	local function fail(s1: string) -- line: 19
		-- upvalues: v6 (copy)
		v6({
			status = "failed",
			error = s1
		})
	end

	return {
		state = v5,
		dispose = function() -- line: 24
		end
	}, succeed, fail
end
local function makeTurnHandle(s2: string) -- line: 51
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
	local t3 = {}
	local u26 = nil
	local u27 = nil
	local n2 = 0
	local t4 = {
		state = v20,
		onNotification = function(p2) -- line: 102
			-- upvalues: n1 (ref), t2 (copy)
			n1 += 1

			local v51 = n1

			t2[v51] = p2

			return function() -- line: 106
				-- upvalues: t2 (copy), v51 (copy)
				t2[v51] = nil
			end
		end,
		getLatestProcessedSequenceNumber = function() -- line: 110
			-- upvalues: u26 (ref)
			return u26
		end,
		hasSequenceGap = function() -- line: 113
			-- upvalues: n2 (ref)
			return n2 > 0
		end,
		noteProcessedSequenceNumber = function(n3: number) -- line: 81
			-- upvalues: t3 (copy), u26 (ref), u27 (ref), n2 (ref)
			if t3[n3] == true then
				return
			end

			t3[n3] = true

			if u26 == nil then
				u26 = n3
				u27 = n3

				return
			end

			if n3 > u26 then
				n2 += n3 - u26 - 1
				u26 = n3

				return
			end

			if n3 < u27 then
				n2 += u27 - n3 - 1
				u27 = n3

				return
			end

			n2 -= 1
		end,
		cancel = function() -- line: 117
			-- upvalues: u22 (ref), v20 (copy), v21 (copy)
			u22 = true

			local v52 = table.clone(v20(false))

			v52.status = "cancelled"
			v52.isDone = true
			v21(v52)
		end
	}

	local function finish(p3) -- line: 126
		-- upvalues: v20 (copy), v21 (copy)
		if p3 ~= nil then
		else
			p3 = table.clone(v20(false))
			p3.status = "succeeded"
			p3.isDone = true
		end

		v21(p3)
	end

	function t4.wasCancelled() -- line: 138
		-- upvalues: u22 (ref)
		return u22
	end
	function t4.setLatestProcessedSequenceNumber(n4: number) -- line: 141
		-- upvalues: t3 (copy), u26 (ref), u27 (ref), n2 (ref)
		if t3[n4] == true then
			return
		end

		t3[n4] = true

		if u26 == nil then
			u26 = n4
			u27 = n4

			return
		end

		if n4 > u26 then
			n2 += n4 - u26 - 1
			u26 = n4

			return
		end

		if n4 < u27 then
			n2 += u27 - n4 - 1
			u27 = n4

			return
		end

		n2 -= 1
	end
	function t4.emitNotification() -- line: 144
		-- upvalues: t2 (copy)
		for _, v56 in t2 do
			v56()
		end
	end

	return t4, finish
end

return {
	Types = require(script.Parent.Parent.types),
	makeRequestHandle = makeRequestHandle,
	makeImmediateSuccess = function(p4) -- line: 29
		-- upvalues: makeRequestHandle (copy)
		local v10, v11 = makeRequestHandle()

		v11(p4)

		return v10
	end,
	makeImmediateFailure = function(s3: string) -- line: 35
		-- upvalues: makeRequestHandle (copy)
		local v13, _, v15 = makeRequestHandle()

		v15(s3)

		return v13
	end,
	makeImmediateFailureWithCode = function(s4: string, n5: number) -- line: 41
		-- upvalues: Signals (copy)
		return {
			state = Signals.createSignal({
				status = "failed",
				error = s4,
				errorCode = n5
			}),
			dispose = function() -- line: 46
			end
		}
	end,
	makeTurnHandle = makeTurnHandle,
	defaultDeps = function() -- line: 152
		-- upvalues: makeRequestHandle (copy), makeTurnHandle (copy)
		local t5 = {}
		local t6 = {}
		local t7 = {}
		local t8 = {}
		local t9 = {}
		local t10 = {}
		local t11 = {}
		local t12 = {}
		local t13 = {}
		local t14 = {}

		return {
			deps = {
				rpcTimeoutSeconds = 5,
				initialize = function(_) -- line: 178
					-- upvalues: t5 (copy), makeRequestHandle (copy)
					table.insert(t5, #t5 + 1)

					local t15 = {
						protocolVersion = 2
					}
					local v59, v60 = makeRequestHandle()

					v60(t15)

					return v59
				end,
				sessionNew = function(p6) -- line: 182
					-- upvalues: t6 (copy), makeRequestHandle (copy)
					table.insert(t6, p6)

					local t16 = {
						sessionId = "cas-session-1"
					}
					local v63, v64 = makeRequestHandle()

					v64(t16)

					return v63
				end,
				sessionLoad = function(p7, p8) -- line: 186
					-- upvalues: t7 (copy), t8 (copy), makeRequestHandle (copy)
					table.insert(t7, {
						sessionId = p7,
						params = p8
					})

					local v67 = t8[#t7] or {}

					if v67.history ~= nil or v67.nextHistoryPageToken ~= nil then
						local v68, v69 = makeRequestHandle()

						v69(v67)

						return v68
					end

					local t17 = {
						history = v67
					}
					local v71, v72 = makeRequestHandle()

					v72(t17)

					return v71
				end,
				sessionPrompt = function(p9) -- line: 194
					-- upvalues: t9 (copy), makeTurnHandle (copy), t13 (copy), t14 (copy)
					table.insert(t9, p9)

					local v74, v75 = makeTurnHandle(p9.sessionId)

					table.insert(t13, v74)
					table.insert(t14, v75)

					return v74
				end,
				ingestSessionHistory = function(p10, p11, p12) -- line: 201
					-- upvalues: t10 (copy), t11 (copy), t12 (copy), t13 (copy)
					table.insert(t10, {
						sessionId = p10,
						history = p11,
						afterSequenceId = p12
					})

					local v79 = t11[#t10]

					if v79 ~= nil then
						return v79
					end

					local t18 = {}

					for _, v82 in p11 do
						local sequenceId = v82.sequenceId

						if typeof(sequenceId) == "number" and (p12 == nil or p12 < sequenceId) then
							if t12[sequenceId] ~= true then
								t12[sequenceId] = true
								table.insert(t18, sequenceId)
							end

							local v84 = t13[#t13]

							if v84 ~= nil and v84.noteProcessedSequenceNumber ~= nil then
								v84.noteProcessedSequenceNumber(sequenceId)
							end
						end
					end

					return t18
				end,
				submitToolResult = function(_) -- line: 227
					-- upvalues: makeRequestHandle (copy)
					local v86, v87 = makeRequestHandle()

					v87(nil)

					return v86
				end,
				getActiveTurnHandle = function(_) -- line: 230
					-- upvalues: t13 (copy)
					return t13[#t13]
				end,
				onCasSessionIdChanged = function(_) -- line: 233
				end
			},
			initializeCalls = t5,
			sessionNewCalls = t6,
			sessionLoadCalls = t7,
			sessionLoadResults = t8,
			sessionPromptCalls = t9,
			ingestSessionHistoryCalls = t10,
			ingestSessionHistoryResults = t11,
			turnHandles = t13,
			finishLastTurn = function(p16) -- line: 247
				-- upvalues: t14 (copy)
				local v91 = t14[#t14]

				if v91 ~= nil then
					v91(p16)
				end
			end
		}
	end,
	awaitTurnHandle = function(p17, n6: number?) -- line: 256
		local v43 = os.clock() + (n6 or 3)

		while p17.getTurnHandle(false) == nil and p17.getSetupError(false) == nil and not (v43 < os.clock()) do
			task.wait()
		end
	end,
	waitFor = function(p18: ((...any) -> ...any), n7: number?) -- line: 266
		local v46 = os.clock() + (n7 or 3)

		while not p18() and not (v46 < os.clock()) do
			task.wait()
		end
	end
}
