local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local function Gradient(p)
	return React.createElement("UIGradient", {
		Rotation = p.fillDirection == Enum.FillDirection.Vertical and 90 or 0,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, p.top and 0 or 1),
			NumberSequenceKeypoint.new(0.5, p.top and 0 or 1),
			NumberSequenceKeypoint.new(0.50001, p.top and 1 or 0),
			NumberSequenceKeypoint.new(1, p.top and 1 or 0)
		})
	})
end

return Gradient
