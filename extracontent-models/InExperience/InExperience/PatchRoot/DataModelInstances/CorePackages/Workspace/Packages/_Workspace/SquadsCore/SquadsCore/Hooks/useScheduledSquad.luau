local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local GetScheduledSquadsStore = require(SquadsCore.Stores.GetScheduledSquadsStore)
require(SquadsCore.Types)

local function useScheduledSquad(p: number)
	local scheduledSquadsStore = GetScheduledSquadsStore(false)

	local v = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return scheduledSquadsStore.getScheduledSquadsStatus(p2)[p]
		end)
	end, { scheduledSquadsStore, p })

	local state, setState = React.useState(function()
		return v(false)
	end)

	React.useLayoutEffect(function()
		setState(v(false))
		return Signals.createEffect(function(p2)
			setState(v(p2))
		end)
	end, { v })

	return state
end

return useScheduledSquad
