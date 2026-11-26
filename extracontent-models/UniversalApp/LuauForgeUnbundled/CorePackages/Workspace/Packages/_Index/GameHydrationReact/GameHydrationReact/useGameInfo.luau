local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/SignalsReact")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")

local function useGameInfo(p2)
	local v5 = tostring(p2)

	local v6 = React.useMemo(function()
		return DataHydration.Game.getGameInfoStore(false).getGameInfo(v5).data
	end, { v5 })

	return SignalsReact.useSignalState(v6)
end

return useGameInfo
