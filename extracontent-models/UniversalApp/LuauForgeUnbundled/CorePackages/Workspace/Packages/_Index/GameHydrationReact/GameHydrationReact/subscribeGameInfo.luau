local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/Signals")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")

local function toId(p2)
	if p2 == nil then
		return nil
	end

	return (tostring(p2))
end

local function subscribeGameInfo(p2)
	local gameInfoStore = DataHydration.Game.getGameInfoStore(false)
	local votesStore = DataHydration.Game.getVotesStore(false)

	local createSignal = Signals.createSignal
	local universeId = p2.universeId
	local v5 = if universeId ~= nil then tostring(universeId) else nil

	local signal, v6 = createSignal(v5)
	local current = {}

	local effect = Signals.createEffect(function(p3)
		local v7 = signal(p3)

		if v7 == nil then
			current = {}
		else
			current = {
				gameInfo = gameInfoStore.getGameInfo(v7).data(p3),
				votes = votesStore.getVote(v7).data(p3)
			}
		end

		p2.onChange(current)
	end)

	return {
		getCurrent = function()
			return current
		end,
		update = function(p3)
			local v8 = if p3 ~= nil then tostring(p3) else nil

			v6(v8)
		end,
		dispose = effect
	}
end

return subscribeGameInfo
