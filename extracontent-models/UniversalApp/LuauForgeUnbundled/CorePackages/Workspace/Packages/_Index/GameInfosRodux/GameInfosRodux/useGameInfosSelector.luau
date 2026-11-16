local GameInfosReducer = require("@game/CorePackages/Workspace/Packages/_Index/GameInfosRodux/GameInfosRodux/GameInfosReducer")

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/RoactUtils").Hooks.RoactRodux.useSelector

local function useGameInfosSelector(p2)
	return (useSelector(function(p3)
		return p3.Personalization[GameInfosReducer.key][p2]
	end))
end

return useGameInfosSelector
