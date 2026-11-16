local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

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
