local parent = script.Parent.Parent

local ControlState = require(parent.Control.Enum.ControlState)

return function(p, p2, p3)
	local v = p[p2] or p[ControlState.Default]

	local v2 = { Color = p3.Theme[v].Color, Transparency = p3.Theme[v].Transparency }

	if p2 == ControlState.Disabled or p2 == ControlState.Pressed then
		v2.Transparency = 0.5 * v2.Transparency + 0.5
	end

	return v2
end
