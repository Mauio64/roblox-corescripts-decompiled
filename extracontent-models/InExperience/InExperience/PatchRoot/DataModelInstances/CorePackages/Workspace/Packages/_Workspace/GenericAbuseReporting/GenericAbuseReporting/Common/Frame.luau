local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local React = require(GenericAbuseReporting.Parent.React)

return (React.forwardRef(function(props, ref)
	return React.createElement("Frame", {
		AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.XY,
		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = props.BackgroundTransparency or 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex,
		children = props.children,
		ref = ref
	})
end))
