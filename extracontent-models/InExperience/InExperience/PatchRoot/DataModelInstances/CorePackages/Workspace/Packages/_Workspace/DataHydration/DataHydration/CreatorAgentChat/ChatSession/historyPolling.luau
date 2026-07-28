require(script.Parent.Parent.types)

local constants = require(script.Parent.constants)
local historyPageUtils = require(script.Parent.historyPageUtils)

require(script.Parent.sessionDeps)

return {
	createHistoryPolling = function(t1: {[any]: any}) -- line: 24
		-- upvalues: historyPageUtils (copy), constants (copy)
		local function pollSessionHistory(s1: string, n1: number?, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)) -- line: 25
			-- upvalues: t1 (copy), historyPageUtils (copy)
			if p2() then
				return false
			end

			local v10 = t1.deps.sessionLoad(s1, nil)
			local v11 = historyPageUtils.awaitRequestState(v10.state, os.clock() + t1.rpcTimeoutSeconds)

			if v11.status == "pending" then
				v10.dispose()

				return false
			end

			if p2() or v11.status ~= "succeeded" then
				return false
			end

			local v12 = historyPageUtils.getSessionLoadHistory(v11.result)

			if #v12 == 0 or p2() then
				return false
			end

			if p2() then
				return false
			end

			t1.mergeHistoryPage(v12, t1.getNextHistoryPageToken())

			local v13 = t1.deps.ingestSessionHistory(s1, v12, n1)

			if p1 ~= nil then
				for _, v15 in v13 do
					p1(v15)
				end
			end

			if p2() then
				return false
			end

			return #v13 > 0
		end
		local function startPollingTurnFromHistory(s2: string, p3, p4) -- line: 67
			-- upvalues: historyPageUtils (copy), constants (copy), t1 (copy), pollSessionHistory (copy)
			local v19 = p4 or {}
			local v20 = historyPageUtils.resolveNonNegativeNumber(v19.rtnIdleFallbackSeconds, constants.getRtnIdleFallbackSeconds())
			local v21 = historyPageUtils.resolveNonNegativeNumber(v19.rtnSequenceGapFallbackSeconds, constants.getRtnSequenceGapFallbackSeconds())
			local v22 = historyPageUtils.resolvePositiveNumber(v19.pollMinIntervalSeconds, constants.getPollMinIntervalSeconds())
			local u23 = historyPageUtils.resolvePositiveNumber(v19.pollMaxIntervalSeconds, constants.getPollMaxIntervalSeconds())

			if v22 > u23 then
				u23 = v22
			end

			local afterSequenceId = v19.afterSequenceId
			local noteProcessedSequenceNumber = p3.noteProcessedSequenceNumber

			if afterSequenceId ~= nil and noteProcessedSequenceNumber ~= nil then
				noteProcessedSequenceNumber(afterSequenceId)
			end

			local u26 = false
			local u27 = false
			local u28 = false
			local u29 = false
			local u30 = false
			local u31 = v22
			local elapsed = os.clock()
			local u33 = false
			local n2 = 0
			local n3 = 0
			local n4 = 0

			local function shouldStopPolling() -- line: 111
				-- upvalues: u26 (ref), p3 (copy), t1 (copy), s2 (copy)
				return u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2)
			end

			local u38 = nil

			local function stopPolling() -- line: 117
				-- upvalues: u27 (ref), u31 (ref), v22 (copy), n4 (ref)
				if not u27 then
					return
				end

				u27 = false
				u31 = v22
				n4 += 1
			end
			local function startPolling() -- line: 126
				-- upvalues: u27 (ref), u26 (ref), p3 (copy), t1 (copy), s2 (copy), u31 (ref), v22 (copy), u38 (ref)
				if u27 or (u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2)) then
					return
				end

				u27 = true
				u31 = v22
				u38(0)
			end
			local function updatePollingState() -- line: 135
				-- upvalues: u26 (ref), p3 (copy), t1 (copy), s2 (copy), u27 (ref), u31 (ref), v22 (copy), n4 (ref), u28 (ref), u30 (ref), u38 (ref)
				if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
					if not u27 then
						return
					end

					u27 = false
					u31 = v22
					n4 += 1

					return
				end

				if u28 or u30 then
					if not u27 then
						if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
							return
						end

						u27 = true
						u31 = v22
						u38(0)

						return
					end
				else
					if not u27 then
						return
					end

					u27 = false
					u31 = v22
					n4 += 1
				end
			end
			local function refreshSequenceGapState() -- line: 145
				-- upvalues: p3 (copy), u29 (ref), u30 (ref), n3 (ref), v21 (copy), u26 (ref), t1 (copy), s2 (copy), u27 (ref), u31 (ref), v22 (copy), n4 (ref), u28 (ref), u38 (ref)
				local hasSequenceGap = p3.hasSequenceGap
				local v50 = hasSequenceGap ~= nil and hasSequenceGap()

				if v50 == u29 then
					return
				end

				u29 = v50
				u30 = false
				n3 += 1

				local v51 = n3

				if v50 then
					task.delay(v21, function() -- line: 157
						-- upvalues: v51 (copy), n3 (ref), u26 (ref), p3 (copy), t1 (copy), s2 (copy), u29 (ref), u30 (ref), u27 (ref), u31 (ref), v22 (copy), n4 (ref), u28 (ref), u38 (ref)
						if v51 ~= n3 or (u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) or not u29) then
							return
						end

						u30 = true

						if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
							if not u27 then
								return
							end

							u27 = false
							u31 = v22
							n4 += 1

							return
						end

						if u28 or u30 then
							if not u27 then
								if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
									return
								end

								u27 = true
								u31 = v22
								u38(0)

								return
							end
						else
							if not u27 then
								return
							end

							u27 = false
							u31 = v22
							n4 += 1
						end
					end)
				end

				if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
					if not u27 then
						return
					end

					u27 = false
					u31 = v22
					n4 += 1

					return
				end

				if u28 or u30 then
					if not u27 then
						if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
							return
						end

						u27 = true
						u31 = v22
						u38(0)

						return
					end
				else
					if not u27 then
						return
					end

					u27 = false
					u31 = v22
					n4 += 1
				end
			end
			local function u43(n5: number) -- line: 169
				-- upvalues: u33 (ref), n2 (ref), u26 (ref), p3 (copy), t1 (copy), s2 (copy), v20 (copy), elapsed (ref), u43 (ref), u28 (ref), u27 (ref), u31 (ref), v22 (copy), n4 (ref), u30 (ref), u38 (ref)
				if u33 then
					return
				end

				u33 = true

				local v53 = n2

				task.delay(n5, function() -- line: 175
					-- upvalues: u33 (ref), v53 (copy), n2 (ref), u26 (ref), p3 (copy), t1 (copy), s2 (copy), v20 (copy), elapsed (ref), u43 (ref), u28 (ref), u27 (ref), u31 (ref), v22 (copy), n4 (ref), u30 (ref), u38 (ref)
					u33 = false

					if v53 ~= n2 or (u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2)) then
						return
					end

					local v56 = v20 - (os.clock() - elapsed)

					if v56 > 0 then
						u43(v56)

						return
					end

					u28 = true

					if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
						if not u27 then
							return
						end

						u27 = false
						u31 = v22
						n4 += 1

						return
					end

					if u28 or u30 then
						if not u27 then
							if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
								return
							end

							u27 = true
							u31 = v22
							u38(0)

							return
						end
					else
						if not u27 then
							return
						end

						u27 = false
						u31 = v22
						n4 += 1
					end
				end)
			end
			local function noteRtnActivity() -- line: 191
				-- upvalues: elapsed (ref), u28 (ref), u26 (ref), p3 (copy), t1 (copy), s2 (copy), u27 (ref), u31 (ref), v22 (copy), n4 (ref), u30 (ref), u38 (ref), u43 (ref), v20 (copy)
				elapsed = os.clock()
				u28 = false

				if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
					if u27 then
						u27 = false
						u31 = v22
						n4 += 1
					end
				elseif u28 or u30 then
					if not u27 and (not u26 and (not p3.state(false).isDone and t1.getCasSessionId() == s2)) then
						u27 = true
						u31 = v22
						u38(0)
					end
				elseif u27 then
					u27 = false
					u31 = v22
					n4 += 1
				end

				u43(v20)
			end

			function u38(n6: number) -- line: 198
				-- upvalues: n4 (ref), u27 (ref), u26 (ref), p3 (copy), t1 (copy), s2 (copy), pollSessionHistory (copy), afterSequenceId (copy), v19 (copy), shouldStopPolling (copy), u31 (ref), v22 (copy), refreshSequenceGapState (copy), u28 (ref), u30 (ref), u38 (ref), u23 (ref), constants (copy)
				n4 += 1

				local v55 = n4

				task.delay(n6, function() -- line: 201
					-- upvalues: v55 (copy), n4 (ref), u27 (ref), u26 (ref), p3 (copy), t1 (copy), s2 (copy), pollSessionHistory (copy), afterSequenceId (copy), v19 (copy), shouldStopPolling (copy), u31 (ref), v22 (copy), refreshSequenceGapState (copy), u28 (ref), u30 (ref), u38 (ref), u23 (ref), constants (copy)
					if v55 ~= n4 or (not u27 or (u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2))) then
						return
					end

					local v57 = pollSessionHistory(s2, afterSequenceId, v19.onDroppedChatMessage, shouldStopPolling)

					if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
						if not u27 then
							return
						end

						u27 = false
						u31 = v22
						n4 += 1

						return
					end

					refreshSequenceGapState()

					if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
						if u27 then
							u27 = false
							u31 = v22
							n4 += 1
						end
					elseif u28 or u30 then
						if not u27 and (not u26 and (not p3.state(false).isDone and t1.getCasSessionId() == s2)) then
							u27 = true
							u31 = v22
							u38(0)
						end
					elseif u27 then
						u27 = false
						u31 = v22
						n4 += 1
					end

					if not u27 then
						return
					end

					if v57 then
						u31 = v22
					else
						u31 = math.min(u23, u31 * constants.getPollBackoffMultiplier())
					end

					u38(u31)
				end)
			end

			local v45 = p3.onNotification(function() -- line: 233
				-- upvalues: elapsed (ref), u28 (ref), u26 (ref), p3 (copy), t1 (copy), s2 (copy), u27 (ref), u31 (ref), v22 (copy), n4 (ref), u30 (ref), u38 (ref), u43 (ref), v20 (copy), refreshSequenceGapState (copy)
				elapsed = os.clock()
				u28 = false

				if u26 or (p3.state(false).isDone or t1.getCasSessionId() ~= s2) then
					if u27 then
						u27 = false
						u31 = v22
						n4 += 1
					end
				elseif u28 or u30 then
					if not u27 and (not u26 and (not p3.state(false).isDone and t1.getCasSessionId() == s2)) then
						u27 = true
						u31 = v22
						u38(0)
					end
				elseif u27 then
					u27 = false
					u31 = v22
					n4 += 1
				end

				u43(v20)
				refreshSequenceGapState()
			end)

			refreshSequenceGapState()
			elapsed = os.clock()
			u28 = false

			if u26 or (p3.state(false).isDone or s2 ~= t1.getCasSessionId()) then
				if u27 then
					u27 = false
					u31 = v22
					n4 += 1
				end
			elseif u28 or u30 then
				if not u27 and (not u26 and (not p3.state(false).isDone and s2 == t1.getCasSessionId())) then
					u27 = true
					u31 = v22
					u38(0)
				end
			elseif u27 then
				u27 = false
				u31 = v22
				n4 += 1
			end

			u43(v20)

			return function() -- line: 241
				-- upvalues: u26 (ref), n2 (ref), n3 (ref), n4 (ref), v45 (copy)
				u26 = true
				n2 += 1
				n3 += 1
				n4 += 1
				v45()
			end
		end

		return {
			startPollingTurnFromHistory = startPollingTurnFromHistory,
			startPollingActiveTurn = function(s3: string, p5) -- line: 250
				-- upvalues: t1 (copy), startPollingTurnFromHistory (copy)
				local v48 = t1.deps.getActiveTurnHandle(s3)

				if v48 == nil then
					return function() -- line: 253
					end
				end

				return (startPollingTurnFromHistory(s3, v48, p5))
			end
		}
	end
}
