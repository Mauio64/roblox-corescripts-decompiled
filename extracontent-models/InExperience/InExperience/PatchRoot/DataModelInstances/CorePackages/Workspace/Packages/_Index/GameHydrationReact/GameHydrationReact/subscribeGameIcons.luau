local parent = script:FindFirstAncestor("GameHydrationReact").Parent

local Signals = require(parent.Signals)
local DataHydration = require(parent.DataHydration)

local function toIds(items)
	local ids = {}

	if items == nil then
		return ids
	end

	local set = {}

	for _, item in items do
		local v = tostring(item)

		if set[v] then
			continue
		end

		set[v] = true
		table.insert(ids, v)
	end

	return ids
end

local function sameIds(list, list2): boolean
	if #list ~= #list2 then
		return false
	end

	local set = {}

	for _, item in list do
		set[item] = true
	end

	for _, item in list2 do
		if not set[item] then
			return false
		end
	end

	return true
end

local function subscribeGameIcons(data)
	local gameIconStore = DataHydration.Game.getGameIconStore(false)

	local signal, v = Signals.createSignal(toIds(data.universeIds), sameIds)
	local current = {}

	local flag = true
	local effect = Signals.createEffect(function(p)
		local v2 = signal(p)
		local data2 = {}

		if #v2 > 0 then
			local gameIcons = gameIconStore.getGameIcons(v2, data.size)

			for k, gameIcon in gameIcons do
				local data3 = gameIcon.data(p)

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
		update = function(p)
			v(toIds(p))
		end,
		dispose = effect
	}
end

return subscribeGameIcons
