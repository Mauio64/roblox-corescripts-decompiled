local GameInfosRodux = script:FindFirstAncestor("GameInfosRodux")
local GameInfosReducer = require(GameInfosRodux.GameInfosReducer)
local GameInfosRoduxParent = GameInfosRodux.Parent
local useSelector = require(GameInfosRoduxParent.RoactUtils).Hooks.RoactRodux.useSelector

local function useGameInfosSelector(p1) -- line: 6
	-- upvalues: useSelector (copy), GameInfosReducer (copy)
	return (useSelector(function(p2) -- line: 7
		-- upvalues: GameInfosReducer (copy), p1 (copy)
		return p2.Personalization[GameInfosReducer.key][p1]
	end))
end

return useGameInfosSelector
