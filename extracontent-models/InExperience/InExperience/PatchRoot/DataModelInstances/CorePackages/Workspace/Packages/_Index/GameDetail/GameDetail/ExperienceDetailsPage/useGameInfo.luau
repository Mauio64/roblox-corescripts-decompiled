local parent = script:FindFirstAncestor("GameDetail").Parent

local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)

local function useGameInfo(p: string)
	return SignalsReact.useSignalState(DataHydration.Game.getGameInfoStore(false).getGameInfo(p).data)
end

return useGameInfo
