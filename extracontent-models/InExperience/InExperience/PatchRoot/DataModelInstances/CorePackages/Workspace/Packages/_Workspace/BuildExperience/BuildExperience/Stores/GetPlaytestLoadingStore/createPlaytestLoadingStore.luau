local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)

local function createPlaytestLoadingStore() -- line: 22
	-- upvalues: Signals (copy)
	local t1 = {}

	local function getLoadingSignal(n1: number) -- line: 35
		-- upvalues: t1 (copy), Signals (copy)
		local v7 = t1[n1]

		if v7 == nil then
			local v8, v9 = Signals.createSignal("Idle")
			local v10, v11 = Signals.createSignal("Idle")
			local v12 = Signals.createComputed(function(p1) -- line: 41
				-- upvalues: v8 (copy), v10 (copy)
				if v8(p1) == "Loading" or v10(p1) == "Loading" then
					return "Loading"
				end

				if v8(p1) == "Completed" or v10(p1) == "Completed" then
					return "Completed"
				end

				return "Idle"
			end)
			local v13 = Signals.createComputed(function(p2) -- line: 51
				-- upvalues: v10 (copy)
				return v10(p2) == "Loading"
			end)

			v7 = {
				getAgentStatus = v8,
				setAgentStatus = v9,
				getPlaytestStatus = v10,
				setPlaytestStatus = v11,
				getStatus = v12,
				getIsPlaytestLoading = v13
			}
			t1[n1] = v7
		end

		return v7
	end

	return {
		getAgentStatusForPlaceId = function(n2: number) -- line: 67
			-- upvalues: getLoadingSignal (copy)
			return getLoadingSignal(n2).getAgentStatus
		end,
		getPlaytestStatusForPlaceId = function(n3: number) -- line: 71
			-- upvalues: getLoadingSignal (copy)
			return getLoadingSignal(n3).getPlaytestStatus
		end,
		getStatusForPlaceId = function(n4: number) -- line: 75
			-- upvalues: getLoadingSignal (copy)
			return getLoadingSignal(n4).getStatus
		end,
		getIsPlaytestLoadingForPlaceId = function(n5: number) -- line: 79
			-- upvalues: getLoadingSignal (copy)
			return getLoadingSignal(n5).getIsPlaytestLoading
		end,
		setAgentStatusForPlaceId = function(n6: number, s1: string) -- line: 83
			-- upvalues: getLoadingSignal (copy)
			getLoadingSignal(n6).setAgentStatus(s1)
		end,
		setPlaytestStatusForPlaceId = function(n7: number, s2: string) -- line: 87
			-- upvalues: getLoadingSignal (copy)
			getLoadingSignal(n7).setPlaytestStatus(s2)
		end,
		clearCompletedStatusForPlaceId = function(n8: number) -- line: 91
			-- upvalues: getLoadingSignal (copy)
			local v23 = getLoadingSignal(n8)

			if v23.getStatus() ~= "Completed" then
				return
			end

			v23.setAgentStatus("Idle")
			v23.setPlaytestStatus("Idle")
		end
	}
end

return createPlaytestLoadingStore
