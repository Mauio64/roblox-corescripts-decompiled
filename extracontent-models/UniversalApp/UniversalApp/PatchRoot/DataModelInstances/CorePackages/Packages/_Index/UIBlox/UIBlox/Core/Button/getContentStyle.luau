local ParentParent = script.Parent.Parent
local ControlState = require(ParentParent.Control.Enum.ControlState)

return function(p1, p2, p3) -- line: 6
	-- upvalues: ControlState (copy)
	local v6 = p1[p2] or p1[ControlState.Default]
	local t1 = {
		Color = p3.Theme[v6].Color,
		Transparency = p3.Theme[v6].Transparency
	}

	if p2 == ControlState.Disabled or p2 == ControlState.Pressed then
		t1.Transparency = 0.5 * t1.Transparency + 0.5
	end

	return t1
end
