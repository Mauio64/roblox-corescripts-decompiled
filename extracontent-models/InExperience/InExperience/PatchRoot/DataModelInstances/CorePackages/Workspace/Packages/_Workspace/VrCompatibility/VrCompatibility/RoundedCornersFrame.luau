local parent = script.Parent.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

return function(props)
	return React.createElement(
		"Frame",
		{
			BackgroundColor3 = props.backgroundColor,
			BackgroundTransparency = props.backgroundTransparency,
			Size = UDim2.new(1, 0, 1, 0)
		},
		Cryo.Dictionary.join({
			Padding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, props.cornerRadius),
				PaddingLeft = UDim.new(0, props.cornerRadius),
				PaddingTop = UDim.new(0, props.cornerRadius),
				PaddingBottom = UDim.new(0, props.cornerRadius)
			}),
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, props.cornerRadius)
			})
		}, props.children)
	)
end
