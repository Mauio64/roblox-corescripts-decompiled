local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local function UIListLayout(props)
	return React.createElement("UIListLayout", {
		HorizontalAlignment = props.HorizontalAlignment,
		FillDirection = props.FillDirection,
		VerticalAlignment = props.VerticalAlignment,
		SortOrder = Enum.SortOrder.LayoutOrder
	})
end

return UIListLayout
