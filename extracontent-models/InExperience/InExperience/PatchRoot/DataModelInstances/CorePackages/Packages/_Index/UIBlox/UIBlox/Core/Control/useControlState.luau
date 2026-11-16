local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent

local React = require(parent2.React)
local ControlState = require(parent.Control.Enum.ControlState)

local function useControlState()
	local state, setState = React.useState(ControlState.Initialize)

	return state, (React.useCallback(function(_, p)
		setState(p)
	end, {}))
end

return useControlState
