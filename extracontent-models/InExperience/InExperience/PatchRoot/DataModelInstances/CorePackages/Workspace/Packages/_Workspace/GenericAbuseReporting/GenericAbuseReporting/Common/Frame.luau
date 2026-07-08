local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local React = require(GenericAbuseReporting.Parent.React)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 15
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		BorderSizePixel = 0,
		AutomaticSize = t1.AutomaticSize or Enum.AutomaticSize.XY,
		BackgroundColor3 = t1.BackgroundColor3,
		BackgroundTransparency = t1.BackgroundTransparency or 1,
		LayoutOrder = t1.LayoutOrder,
		Position = t1.Position,
		Size = t1.Size or UDim2.fromScale(1, 1),
		ZIndex = t1.ZIndex,
		children = t1.children,
		ref = p1
	})
end))
