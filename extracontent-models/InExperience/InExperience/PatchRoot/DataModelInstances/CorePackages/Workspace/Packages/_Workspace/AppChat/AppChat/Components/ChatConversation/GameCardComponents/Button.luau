local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local v3 = Roact.PureComponent:extend("Button")

v3.defaultProps = {
	transparency = 0,
	textSize = 12,
	text = "",
	LayoutOrder = 0,
	color = Color3.new(0.9, 0.9, 0.9),
	textColor = Color3.new(0.1, 0.1, 0.1),
	font = Enum.Font.Gotham,
	onActivated = function() -- line: 17
		print("Game card button activated!")
	end
}

function v3.render(p1) -- line: 22
	-- upvalues: Roact (copy)
	local v5 = Roact.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Image = "rbxasset://textures/ui/LuaChat/9-slice/input-default.png",
		ImageColor3 = p1.props.color,
		ImageTransparency = p1.props.transparency,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(3, 3, 4, 4),
		[Roact.Event.Activated] = p1.props.onActivated
	}, {
		layout = Roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		actionLabel = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.8, 0, 0.8, 0),
			TextSize = p1.props.textSize,
			TextColor3 = p1.props.textColor,
			Font = p1.props.font,
			Text = p1.props.text or ""
		})
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 32),
		LayoutOrder = p1.props.LayoutOrder or 0
	}, {
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		actionButton = v5
	})
end

return v3
