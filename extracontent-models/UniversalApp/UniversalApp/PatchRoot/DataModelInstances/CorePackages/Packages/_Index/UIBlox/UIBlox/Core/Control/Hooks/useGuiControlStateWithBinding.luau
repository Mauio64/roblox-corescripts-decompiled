local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)

local ControlState = require(parent2.Core.Control.Enum.ControlState)
local useGuiControlState = require(parent.Control.Hooks.useGuiControlState)

local function useGuiControlStateWithBinding(p, callback, flag: boolean)
	local v, v2 = React.useBinding(ControlState.Initialize)
	local v3, _ = useGuiControlState(p, React.useCallback(function(p2, p3)
		v2((tostring(p3)))

		if callback then
			callback(p2, p3)
		end
	end, {}), flag)

	return v3, v
end

return useGuiControlStateWithBinding
