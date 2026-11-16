local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/Signals")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")

local function toIds(items)
	local ids = {}

	if items == nil then
		return ids
	end

	local set = {}

	for k, item in items do
		local v5 = tostring(item)

		if set[v5] then
			continue
		end

		set[v5] = true
		table.insert(ids, v5)
	end

	return ids
end

local function sameIds(list, list2): boolean
	if #list ~= #list2 then
		return false
	end

	local set = {}

	for k, item in list do
		set[item] = true
	end

	for k, item in list2 do
		if not set[item] then
			return false
		end
	end

	return true
end

local function subscribeGameIcons(data)
	local gameIconStore = DataHydration.Game.getGameIconStore(false)

	local signal, v5 = Signals.createSignal(toIds(data.universeIds), sameIds)
	local current = {}

	local flag = true
	local effect = Signals.createEffect(function(p2)
		local v6 = signal(p2)
		local data2 = {}

		if #v6 > 0 then
			local gameIcons = gameIconStore.getGameIcons(v6, data.size)

			for k, gameIcon in gameIcons do
				local data3 = gameIcon.data(p2)

				if data3 ~= nil then
					data2[k] = data3
				end
			end
		end

		current = data2

		if flag then
			flag = false
		else
			data.onChange(data2)
		end
	end)

	return {
		getCurrent = function()
			return current
		end,
		update = function(p2)
			v5(toIds(p2))
		end,
		dispose = effect
	}
end

return subscribeGameIcons
