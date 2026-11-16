local AppChat = script:FindFirstAncestor("AppChat")
local React = require(AppChat.Parent.React)

local function UIListLayout(props)
	return React.createElement("UIListLayout", {
		HorizontalAlignment = props.HorizontalAlignment,
		FillDirection = props.FillDirection,
		VerticalAlignment = props.VerticalAlignment,
		SortOrder = Enum.SortOrder.LayoutOrder
	})
end

return UIListLayout
