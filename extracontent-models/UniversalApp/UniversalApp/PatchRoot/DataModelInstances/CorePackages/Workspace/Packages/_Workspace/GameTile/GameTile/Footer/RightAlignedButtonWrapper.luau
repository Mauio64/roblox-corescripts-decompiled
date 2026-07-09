local Parent = script:FindFirstAncestor("GameTile").Parent
local React = require(Parent.React)

return function(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy)
	if not t1.Button then
		return t1.Content
	end

	return React.createElement(React.Fragment, nil, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = t1.Padding
		}),
		FooterContentWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = -1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Shrink
			}),
			Content = t1.Content
		}),
		Button = t1.Button
	})
end
