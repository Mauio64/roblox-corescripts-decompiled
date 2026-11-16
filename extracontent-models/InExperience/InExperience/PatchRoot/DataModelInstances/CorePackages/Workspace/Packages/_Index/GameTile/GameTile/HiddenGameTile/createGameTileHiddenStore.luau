local parent = script:FindFirstAncestor("GameTile").Parent
local Signals = require(parent.Signals)

local function createGameTileHiddenStore()
	local signal, v = Signals.createSignal({})

	return {
		setGameHidden = function(p: string, flag: boolean)
			local clone = table.clone(signal(false))
			clone[p] = flag
			v(clone)
		end,
		getHiddenGames = signal
	}
end

return createGameTileHiddenStore
