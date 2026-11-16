local parent = script.Parent.Parent.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

require(parent.CoreScriptsRoactCommon)

local function useSignalMapState(p)
	local state, setState = React.useState(p)

	React.useLayoutEffect(function()
		setState(p)
		return Signals.createEffect(function(p2)
			p.getCount(p2)
			setState(p)
		end)
	end, { p })

	return state
end

return useSignalMapState
