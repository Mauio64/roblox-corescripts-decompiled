local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Signals = require(parent.Signals)

local function createRecentlyLeftStore(callback)
	local v = callback or os.clock
	local signal, v2 = Signals.createSignal({})
	local computed = Signals.createComputed(function(p)
		local result = {}

		for k in signal(p) do
			result[k] = true
		end

		return result
	end)

	local flag = false

	local function prune(items)
		local v3 = v()
		local result = {}

		for k, item in items do
			if v3 - item.leftAtClock <= 120 then
				result[k] = item
			end
		end

		return result
	end

	local function handlePlayerRemoving(player)
		local localPlayer = Players.LocalPlayer

		if localPlayer and player.UserId == localPlayer.UserId then
			return
		end

		local clone = table.clone(signal(false))
		clone[tostring(player.UserId)] = {
			userId = player.UserId,
			username = player.Name,
			displayName = player.DisplayName,
			leftAtClock = v()
		}

		v2(prune(clone))
	end

	local function handlePlayerAdded(p)
		local v3 = signal(false)

		if v3[tostring(p.UserId)] == nil then
			return
		end

		local clone = table.clone(v3)
		clone[tostring(p.UserId)] = nil
		v2(prune(clone))
	end

	return {
		init = function()
			if flag then
				return
			end

			flag = true
			Players.PlayerRemoving:Connect(handlePlayerRemoving)
			Players.PlayerAdded:Connect(handlePlayerAdded)
		end,
		getRecentlyLeft = function()
			local v3 = prune(signal(false))
			local recentlyLeft = {}

			for _, v4 in v3 do
				table.insert(recentlyLeft, {
					userId = v4.userId,
					username = v4.username,
					displayName = v4.displayName
				})
			end

			return recentlyLeft
		end,
		getRecentlyLeftIds = function()
			return computed
		end,
		handlePlayerRemoving = handlePlayerRemoving,
		handlePlayerAdded = handlePlayerAdded
	}
end

local recentlyLeftStore = createRecentlyLeftStore()

return {
	init = recentlyLeftStore.init,
	getRecentlyLeft = recentlyLeftStore.getRecentlyLeft,
	getRecentlyLeftIds = recentlyLeftStore.getRecentlyLeftIds,
	handlePlayerRemoving = recentlyLeftStore.handlePlayerRemoving,
	handlePlayerAdded = recentlyLeftStore.handlePlayerAdded,
	createRecentlyLeftStore = createRecentlyLeftStore
}
