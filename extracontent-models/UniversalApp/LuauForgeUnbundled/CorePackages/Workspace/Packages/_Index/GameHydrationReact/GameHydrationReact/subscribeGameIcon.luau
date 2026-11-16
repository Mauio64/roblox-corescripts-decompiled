local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/Signals")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")

local function toId(p2)
	if p2 == nil then
		return nil
	end

	return (tostring(p2))
end

local function subscribeGameIcon(data)
	local gameIconStore = DataHydration.Game.getGameIconStore(false)

	local universeId = data.universeId
	local v5 = if universeId ~= nil then tostring(universeId) else nil

	local signal, v6 = Signals.createSignal(v5)
	local current = nil

	local flag = true
	local effect = Signals.createEffect(function(p2)
		local v7 = signal(p2)

		current = if v7 ~= nil then gameIconStore.getGameIcon(v7, data.size).data(p2) else nil

		if flag then
			flag = false
		else
			data.onChange(current)
		end
	end)

	return {
		getCurrent = function()
			return current
		end,
		update = function(p2)
			local v8 = if p2 ~= nil then tostring(p2) else nil

			v6(v8)
		end,
		dispose = effect
	}
end

return subscribeGameIcon
