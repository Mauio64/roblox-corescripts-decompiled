local Players = game:GetService("Players")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Signals")

local function createRecentlyLeftStore(p2)
	local v5 = p2 or os.clock
	local signal, v6 = Signals.createSignal({})
	local computed = Signals.createComputed(function(p3)
		local result = {}

		for k in signal(p3) do
			result[k] = true
		end

		return result
	end)

	local flag = false

	local function prune(items)
		local v7 = v5()
		local result = {}

		for k, item in items do
			if v7 - item.leftAtClock <= 120 then
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
			leftAtClock = v5()
		}

		v6(prune(clone))
	end

	local function handlePlayerAdded(p3)
		local v7 = signal(false)

		if v7[tostring(p3.UserId)] == nil then
			return
		end

		local clone = table.clone(v7)
		clone[tostring(p3.UserId)] = nil
		v6(prune(clone))
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
			local v7 = prune(signal(false))
			local recentlyLeft = {}

			for k, v8 in v7 do
				table.insert(recentlyLeft, {
					userId = v8.userId,
					username = v8.username,
					displayName = v8.displayName
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
