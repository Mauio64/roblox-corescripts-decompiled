local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local React = require(parent.React)

local function SelectableUsername(props)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 0)
		}),
		username = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = props.prefixText,
			RichText = true,
			TextTransparency = 1,
			TextStrokeTransparency = 1,
			TextWrapped = false,
			FontFace = props.fontFace,
			TextSize = props.textSize,
			AutoButtonColor = false,
			SelectionImageObject = props.selectionCursor,
			LayoutOrder = 1,
			ref = props.buttonRef
		})
	})
end

return React.memo(SelectableUsername)
