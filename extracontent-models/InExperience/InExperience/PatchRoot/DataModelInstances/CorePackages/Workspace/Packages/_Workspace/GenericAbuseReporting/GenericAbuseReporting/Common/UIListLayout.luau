local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local React = require(GenericAbuseReporting.Parent.React)

local function UIListLayout(props)
	return React.createElement("UIListLayout", {
		FillDirection = props.FillDirection,
		HorizontalAlignment = props.HorizontalAlignment,
		Padding = props.Padding,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = props.VerticalAlignment,
		ref = props.Ref
	})
end

return UIListLayout
