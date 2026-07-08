local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

local function Gradient(t1: {[any]: any}) -- line: 11
	-- upvalues: React (copy)
	return React.createElement("UIGradient", {
		Rotation = t1.fillDirection ~= Enum.FillDirection.Vertical and 0 or 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, not t1.top and 1 or 0),
			NumberSequenceKeypoint.new(0.5, not t1.top and 1 or 0),
			NumberSequenceKeypoint.new(0.50001, not t1.top and 0 or 1),
			NumberSequenceKeypoint.new(1, not t1.top and 0 or 1)
		})
	})
end

return Gradient
