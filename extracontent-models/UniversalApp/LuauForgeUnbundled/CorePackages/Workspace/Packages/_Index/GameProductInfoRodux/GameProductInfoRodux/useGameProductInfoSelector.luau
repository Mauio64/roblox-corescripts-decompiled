local GamesProductInfoReducer = require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/GamesProductInfoReducer")

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameProductInfoRodux/RoactUtils").Hooks.RoactRodux.useSelector

local function useGameProductInfoSelector(p2)
	return (useSelector(function(p3)
		return p3[GamesProductInfoReducer.key][p2]
	end))
end

return useGameProductInfoSelector
