local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local React = require(ParentParent2.React)
local ControlState = require(ParentParent.Control.Enum.ControlState)

local function useControlState() -- line: 20
	-- upvalues: React (copy), ControlState (copy)
	local v6, v7 = React.useState(ControlState.Initialize)

	return v6, (React.useCallback(function(_, p2) -- line: 23
		-- upvalues: v7 (copy)
		v7(p2)
	end, {}))
end

return useControlState
