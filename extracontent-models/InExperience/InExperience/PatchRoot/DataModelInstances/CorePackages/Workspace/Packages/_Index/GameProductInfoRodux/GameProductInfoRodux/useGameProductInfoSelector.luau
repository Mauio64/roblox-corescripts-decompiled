local GameProductInfoRodux = script:FindFirstAncestor("GameProductInfoRodux")
local GamesProductInfoReducer = require(GameProductInfoRodux.GamesProductInfoReducer)

local parent = GameProductInfoRodux.Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useGameProductInfoSelector(p)
	return (useSelector(function(p2)
		return p2[GamesProductInfoReducer.key][p]
	end))
end

return useGameProductInfoSelector
