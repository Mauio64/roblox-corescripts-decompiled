local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/SignalsReact")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")

local function useGameIconForSize(p2, p3)
	local v5 = tostring(p2)

	local v6 = React.useMemo(function()
		local gameIcon = DataHydration.Game.getGameIconStore(false).getGameIcon(v5, p3)
		return function(p4)
			local data = gameIcon.data(p4)

			if data then
				return data.url
			end

			return nil
		end
	end, { v5, p3 })

	return SignalsReact.useSignalState(v6)
end

return useGameIconForSize
