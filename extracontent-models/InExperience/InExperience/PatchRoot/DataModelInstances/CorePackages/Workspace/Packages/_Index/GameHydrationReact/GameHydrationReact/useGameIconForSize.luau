local parent = script:FindFirstAncestor("GameHydrationReact").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)

local function useGameIconForSize(p, p2)
	local v = tostring(p)

	local v2 = React.useMemo(function()
		local gameIcon = DataHydration.Game.getGameIconStore(false).getGameIcon(v, p2)
		return function(p3)
			local data = gameIcon.data(p3)
			return if data then data.url else nil
		end
	end, { v, p2 })

	return SignalsReact.useSignalState(v2)
end

return useGameIconForSize
