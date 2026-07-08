local GameProductInfoRodux = script:FindFirstAncestor("GameProductInfoRodux")
local GamesProductInfoReducer = require(GameProductInfoRodux.GamesProductInfoReducer)
local GameProductInfoRoduxParent = GameProductInfoRodux.Parent
local useSelector = require(GameProductInfoRoduxParent.RoactUtils).Hooks.RoactRodux.useSelector

local function useGameProductInfoSelector(p1) -- line: 8
	-- upvalues: useSelector (copy), GamesProductInfoReducer (copy)
	return (useSelector(function(p2) -- line: 9
		-- upvalues: GamesProductInfoReducer (copy), p1 (copy)
		return p2[GamesProductInfoReducer.key][p1]
	end))
end

return useGameProductInfoSelector
