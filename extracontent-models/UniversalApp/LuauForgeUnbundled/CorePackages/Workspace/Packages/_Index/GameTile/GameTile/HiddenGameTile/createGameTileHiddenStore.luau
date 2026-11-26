local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Signals")

local function createGameTileHiddenStore()
	local signal, v5 = Signals.createSignal({})

	return {
		setGameHidden = function(p2, p3)
			local clone = table.clone(signal(false))
			clone[p2] = p3
			v5(clone)
		end,
		getHiddenGames = signal
	}
end

return createGameTileHiddenStore
