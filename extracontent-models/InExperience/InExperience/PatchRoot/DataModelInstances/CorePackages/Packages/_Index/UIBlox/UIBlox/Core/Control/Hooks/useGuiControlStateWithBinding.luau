local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)
local ControlState = require(ParentParentParent.Core.Control.Enum.ControlState)
local useGuiControlState = require(ParentParent.Control.Hooks.useGuiControlState)

local function useGuiControlStateWithBinding(p1, p2, b1: boolean) -- line: 14
	-- upvalues: React (copy), ControlState (copy), useGuiControlState (copy)
	local v11, v12 = React.useBinding(ControlState.Initialize)
	local v13 = React.useCallback(function(p3, p4) -- line: 20
		-- upvalues: v12 (copy), p2 (copy)
		v12((tostring(p4)))

		if p2 then
			p2(p3, p4)
		end
	end, {})
	local v14, _ = useGuiControlState(p1, v13, b1)

	return v14, v11
end

return useGuiControlStateWithBinding
