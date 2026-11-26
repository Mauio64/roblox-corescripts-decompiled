local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")

return function(props)
	if props.Button then
		return React.createElement(React.Fragment, nil, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = props.Padding
			}),
			FooterContentWrapper = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = -1
				},
				{
					React.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Shrink
					}),
					Content = props.Content
				}
			),
			Button = props.Button
		})
	end

	return props.Content
end
