local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local React = require(parent.React)

local function TranslateHitOverlay(props)
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
		prefixSpacer = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = props.prefixText .. " ",
			RichText = true,
			TextTransparency = 1,
			TextStrokeTransparency = 1,
			TextWrapped = false,
			FontFace = props.fontFace,
			TextSize = props.textSize,
			Active = false,
			AutoButtonColor = false,
			Selectable = false,
			LayoutOrder = 1
		}),
		icon = React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/translateIcon.png",
			HoverImage = "rbxasset://textures/translateIconDark.png",
			PressedImage = "rbxasset://textures/translateIconDark.png",
			Size = UDim2.fromOffset(props.textSize - 2, props.textSize - 2),
			AutoButtonColor = false,
			Selectable = false,
			LayoutOrder = 2,
			[React.Event.Activated] = props.onActivated
		})
	})
end

return React.memo(TranslateHitOverlay)
