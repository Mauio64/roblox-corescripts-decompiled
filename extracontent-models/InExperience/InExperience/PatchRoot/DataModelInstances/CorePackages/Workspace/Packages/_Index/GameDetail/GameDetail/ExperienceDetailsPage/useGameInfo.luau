local Parent = script:FindFirstAncestor("GameDetail").Parent
local SignalsReact = require(Parent.SignalsReact)
local DataHydration = require(Parent.DataHydration)

local function useGameInfo(s1: string) -- line: 9
	-- upvalues: SignalsReact (copy), DataHydration (copy)
	return SignalsReact.useSignalState(DataHydration.Game.getGameInfoStore(false).getGameInfo(s1).data)
end

return useGameInfo
