local parent = script:FindFirstAncestor("GameHydrationReact").Parent

local Signals = require(parent.Signals)
local DataHydration = require(parent.DataHydration)

local function toId(p) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return nil
	end

	return (tostring(p))
end

local function subscribeGameInfo(p)
	local gameInfoStore = DataHydration.Game.getGameInfoStore(false)
	local votesStore = DataHydration.Game.getVotesStore(false)

	local signal, v = Signals.createSignal(toId(p.universeId)) -- inferred equivalent call
	local current = {}

	local effect = Signals.createEffect(function(p2)
		local v2 = signal(p2)

		if v2 == nil then
			current = {}
		else
			current = {
				gameInfo = gameInfoStore.getGameInfo(v2).data(p2),
				votes = votesStore.getVote(v2).data(p2)
			}
		end

		p.onChange(current)
	end)

	return {
		getCurrent = function()
			return current
		end,
		update = function(p2)
			v(toId(p2)) -- inferred equivalent call
		end,
		dispose = effect
	}
end

return subscribeGameInfo
