local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")

local GetScheduledSquadsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetScheduledSquadsStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types")

local function useScheduledSquad(p2)
	local v5 = GetScheduledSquadsStore(false)

	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			return v5.getScheduledSquadsStatus(p3)[p2]
		end)
	end, { v5, p2 })

	local state, setState = React.useState(function()
		return v6(false)
	end)

	React.useLayoutEffect(function()
		setState(v6(false))
		return Signals.createEffect(function(p3)
			setState(v6(p3))
		end)
	end, { v6 })

	return state
end

return useScheduledSquad
