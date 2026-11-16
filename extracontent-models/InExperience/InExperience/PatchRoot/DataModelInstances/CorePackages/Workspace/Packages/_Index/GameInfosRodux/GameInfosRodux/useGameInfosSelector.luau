local GameInfosRodux = script:FindFirstAncestor("GameInfosRodux")
local GameInfosReducer = require(GameInfosRodux.GameInfosReducer)
local parent = GameInfosRodux.Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useGameInfosSelector(p)
	return (useSelector(function(p2)
		return p2.Personalization[GameInfosReducer.key][p]
	end))
end

return useGameInfosSelector
