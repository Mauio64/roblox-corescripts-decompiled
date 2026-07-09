local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)

return {
	createSessionScalarState = function(s1: string?) -- line: 28
		-- upvalues: Signals (copy)
		local v4, v5 = Signals.createSignal(s1)
		local v6, v7 = Signals.createSignal(false)
		local v8, v9 = Signals.createSignal(nil)
		local v10, v11 = Signals.createSignal(false)
		local v12, v13 = Signals.createSignal(false)
		local v14, v15 = Signals.createSignal(0)
		local v16, v17 = Signals.createSignal(nil)

		return {
			getCasSessionId = v4,
			setCasSessionId = v5,
			getHasLoadedHistory = v6,
			setHasLoadedHistory = v7,
			markHistoryLoaded = function() -- line: 63
				-- upvalues: v7 (copy)
				v7(true)
			end,
			getNextHistoryPageToken = v8,
			setNextHistoryPageToken = v9,
			getHistoryLoadInFlight = v10,
			setHistoryLoadInFlight = v11,
			getInitialized = v12,
			setInitialized = v13,
			getAssistantTurnSequence = v14,
			incrementAssistantTurnSequence = function() -- line: 52
				-- upvalues: v14 (copy), v15 (copy)
				local v21 = v14(false) + 1

				v15(v21)

				return v21
			end,
			getLatestObservedHistorySequenceId = v16,
			setLatestObservedHistorySequenceId = function(n1: number?) -- line: 38
				-- upvalues: v17 (copy)
				v17(n1)
			end,
			noteHistorySequenceId = function(n2: number?) -- line: 42
				-- upvalues: v16 (copy), v17 (copy)
				if n2 == nil then
					return
				end

				local v20 = v16(false)

				if v20 == nil or v20 < n2 then
					v17(n2)
				end
			end
		}
	end
}
