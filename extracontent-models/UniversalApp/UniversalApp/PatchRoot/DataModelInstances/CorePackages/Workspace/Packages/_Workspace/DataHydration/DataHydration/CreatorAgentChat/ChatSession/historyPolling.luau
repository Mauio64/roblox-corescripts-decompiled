require(script.Parent.Parent.types)

local constants = require(script.Parent.constants)
local historyPageUtils = require(script.Parent.historyPageUtils)

require(script.Parent.sessionDeps)

return {
	createHistoryPolling = function(t1: {[any]: any}) -- line: 23
		-- upvalues: historyPageUtils (copy), constants (copy)
		local function pollSessionHistory(s1: string, n1: number?, p1: ((...any) -> ...any)) -- line: 24
			-- upvalues: t1 (copy), historyPageUtils (copy)
			if p1() then
				return false
			end

			local v9 = t1.deps.sessionLoad(s1, nil)
			local v10 = historyPageUtils.awaitRequestState(v9.state, os.clock() + t1.rpcTimeoutSeconds)

			if v10.status == "pending" then
				v9.dispose()

				return false
			end

			if p1() or v10.status ~= "succeeded" then
				return false
			end

			local v11 = historyPageUtils.getSessionLoadHistory(v10.result)

			if #v11 == 0 or p1() then
				return false
			end

			if p1() then
				return false
			end

			t1.mergeHistoryPage(v11, t1.getNextHistoryPageToken())

			local v12 = t1.deps.ingestSessionHistory(s1, v11, n1)

			if p1() then
				return false
			end

			return v12
		end
		local function startPollingTurnFromHistory(s2: string, p2, p3) -- line: 60
			-- upvalues: historyPageUtils (copy), constants (copy), pollSessionHistory (copy)
			local v16 = p3 or {}
			local v17 = historyPageUtils.resolveNonNegativeNumber(v16.rtnIdleFallbackSeconds, constants.getRtnIdleFallbackSeconds())
			local v18 = historyPageUtils.resolvePositiveNumber(v16.pollMinIntervalSeconds, constants.getPollMinIntervalSeconds())
			local u19 = historyPageUtils.resolvePositiveNumber(v16.pollMaxIntervalSeconds, constants.getPollMaxIntervalSeconds())

			if v18 > u19 then
				u19 = v18
			end

			local u20 = false
			local u21 = false
			local n2 = 0
			local u23 = v18
			local elapsed = os.clock()
			local v25 = p2.onNotification(function() -- line: 88
				-- upvalues: elapsed (ref), u21 (ref), u23 (ref), v18 (copy)
				elapsed = os.clock()
				u21 = false
				u23 = v18
			end)

			task.spawn(function() -- line: 94
				-- upvalues: u20 (ref), p2 (copy), u21 (ref), elapsed (ref), v17 (copy), n2 (ref), u23 (ref), v18 (copy), pollSessionHistory (copy), s2 (copy), v16 (copy), u19 (ref), constants (copy), v25 (copy)
				while not u20 and not p2.state(false).isDone do
					local elapsed2 = os.clock()

					if not u21 and elapsed2 - elapsed >= v17 then
						u21 = true
						n2 = elapsed2
						u23 = v18
					end

					if u21 and elapsed2 >= n2 then
						local v30 = pollSessionHistory(s2, v16.afterSequenceId, function() -- line: 104
							-- upvalues: u20 (ref), p2 (copy)
							return u20 or p2.state(false).isDone
						end)

						if u20 or p2.state(false).isDone then
							break
						end

						if u21 then
							if v30 then
								u23 = v18
							else
								u23 = math.min(u19, u23 * constants.getPollBackoffMultiplier())
							end

							n2 = os.clock() + u23
						end
					end

					task.wait()
				end

				v25()
			end)

			return function() -- line: 128
				-- upvalues: u20 (ref), v25 (copy)
				u20 = true
				v25()
			end
		end

		return {
			startPollingTurnFromHistory = startPollingTurnFromHistory,
			startPollingActiveTurn = function(s3: string, p4) -- line: 134
				-- upvalues: t1 (copy), startPollingTurnFromHistory (copy)
				local v28 = t1.deps.getActiveTurnHandle(s3)

				if v28 == nil then
					return function() -- line: 137
					end
				end

				return (startPollingTurnFromHistory(s3, v28, p4))
			end
		}
	end
}
