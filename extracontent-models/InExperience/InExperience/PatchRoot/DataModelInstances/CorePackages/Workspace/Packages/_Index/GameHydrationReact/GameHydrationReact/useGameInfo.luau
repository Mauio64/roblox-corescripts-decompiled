local parent = script:FindFirstAncestor("GameHydrationReact").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)

local function useGameInfo(p)
	local v = tostring(p)

	local v2 = React.useMemo(function()
		return DataHydration.Game.getGameInfoStore(false).getGameInfo(v).data
	end, { v })

	return SignalsReact.useSignalState(v2)
end

return useGameInfo
