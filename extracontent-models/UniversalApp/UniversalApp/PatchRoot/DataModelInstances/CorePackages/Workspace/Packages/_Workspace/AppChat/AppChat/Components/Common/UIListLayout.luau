local AppChat = script:FindFirstAncestor("AppChat")
local React = require(AppChat.Parent.React)

local function UIListLayout(t1: {[any]: any}) -- line: 10
	-- upvalues: React (copy)
	return React.createElement("UIListLayout", {
		HorizontalAlignment = t1.HorizontalAlignment,
		FillDirection = t1.FillDirection,
		VerticalAlignment = t1.VerticalAlignment,
		SortOrder = Enum.SortOrder.LayoutOrder
	})
end

return UIListLayout
