local parent = script:FindFirstAncestor("GameHydrationReact").Parent

local Signals = require(parent.Signals)
local DataHydration = require(parent.DataHydration)

local function toId(p) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return nil
	end

	return (tostring(p))
end

local function subscribeGameIcon(data)
	local gameIconStore = DataHydration.Game.getGameIconStore(false)

	local id = toId(data.universeId) -- inferred equivalent call
	local signal, v = Signals.createSignal(id)
	local current = nil

	local flag = true
	local effect = Signals.createEffect(function(p)
		local v2 = signal(p)

		if v2 == nil then
			current = nil
		else
			current = gameIconStore.getGameIcon(v2, data.size).data(p)
		end

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
		update = function(p)
			v(toId(p)) -- inferred equivalent call
		end,
		dispose = effect
	}
end

return subscribeGameIcon
