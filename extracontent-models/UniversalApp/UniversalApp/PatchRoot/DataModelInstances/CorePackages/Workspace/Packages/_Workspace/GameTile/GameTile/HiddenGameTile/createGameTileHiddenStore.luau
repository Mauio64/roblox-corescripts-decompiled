local Parent = script:FindFirstAncestor("GameTile").Parent
local Signals = require(Parent.Signals)

local function createGameTileHiddenStore() -- line: 15
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal({})

	return {
		setGameHidden = function(s1: string, b1: boolean) -- line: 18
			-- upvalues: v4 (copy), v5 (copy)
			local v8 = table.clone(v4(false))

			v8[s1] = b1
			v5(v8)
		end,
		getHiddenGames = v4
	}
end

return createGameTileHiddenStore
