local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SignalsReact")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DataHydration")

local function useGameInfo(p2)
	return SignalsReact.useSignalState(DataHydration.Game.getGameInfoStore(false).getGameInfo(p2).data)
end

return useGameInfo
