local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Signals = require(Parent.Signals)

local function createRecentlyLeftStore(p1: ((...any) -> ...any)?) -- line: 43
	-- upvalues: Signals (copy), Players (copy)
	local v7 = p1 or os.clock
	local v8, v9 = Signals.createSignal({})
	local v10 = Signals.createComputed(function(p2) -- line: 46
		-- upvalues: v8 (copy)
		local t1 = {}

		for v17 in v8(p2) do
			t1[v17] = true
		end

		return t1
	end)
	local u11 = false

	local function prune(t2: {[any]: any}) -- line: 55
		-- upvalues: v7 (copy)
		local v19 = v7()
		local t3 = {}

		for v21, v22 in t2 do
			if v19 - v22.leftAtClock <= 120 then
				t3[v21] = v22
			end
		end

		return t3
	end
	local function handlePlayerRemoving(p3) -- line: 67
		-- upvalues: Players (copy), v8 (copy), v7 (copy), v9 (copy), prune (copy)
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer and p3.UserId == LocalPlayer.UserId then
			return
		end

		local v25 = table.clone(v8(false))

		v25[tostring(p3.UserId)] = {
			userId = p3.UserId,
			username = p3.Name,
			displayName = p3.DisplayName,
			leftAtClock = v7()
		}
		v9((prune(v25)))
	end
	local function handlePlayerAdded(p4) -- line: 83
		-- upvalues: v8 (copy), v9 (copy), prune (copy)
		local v27 = v8(false)

		if v27[tostring(p4.UserId)] == nil then
			return
		end

		local v28 = table.clone(v27)

		v28[tostring(p4.UserId)] = nil
		v9((prune(v28)))
	end

	return {
		init = function() -- line: 93
			-- upvalues: u11 (ref), Players (copy), handlePlayerRemoving (copy), handlePlayerAdded (copy)
			if u11 then
				return
			end

			u11 = true
			Players.PlayerRemoving:Connect(handlePlayerRemoving)
			Players.PlayerAdded:Connect(handlePlayerAdded)
		end,
		getRecentlyLeft = function() -- line: 102
			-- upvalues: prune (copy), v8 (copy)
			local t4 = {}

			for _, v31 in (prune(v8(false))) do
				table.insert(t4, {
					userId = v31.userId,
					username = v31.username,
					displayName = v31.displayName
				})
			end

			return t4
		end,
		getRecentlyLeftIds = function() -- line: 115
			-- upvalues: v10 (copy)
			return v10
		end,
		handlePlayerRemoving = handlePlayerRemoving,
		handlePlayerAdded = handlePlayerAdded
	}
end

local v5 = createRecentlyLeftStore()

return {
	init = v5.init,
	getRecentlyLeft = v5.getRecentlyLeft,
	getRecentlyLeftIds = v5.getRecentlyLeftIds,
	handlePlayerRemoving = v5.handlePlayerRemoving,
	handlePlayerAdded = v5.handlePlayerAdded,
	createRecentlyLeftStore = createRecentlyLeftStore
}
