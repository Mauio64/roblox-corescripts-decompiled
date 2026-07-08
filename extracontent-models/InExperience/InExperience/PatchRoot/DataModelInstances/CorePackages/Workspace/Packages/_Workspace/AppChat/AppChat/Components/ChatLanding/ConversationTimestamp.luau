local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local v3 = Roact.PureComponent:extend("ConversationTimestamp")

v3.defaultProps = {
	text = "TEST",
	textSize = 24,
	textWidth = 32,
	paddingX = 0,
	paddingY = 0,
	currentStyle = nil
}

function v3.render(p1) -- line: 16
	-- upvalues: Roact (copy)
	local textSize = p1.props.textSize
	local textWidth = p1.props.textWidth
	local currentStyle = p1.props.currentStyle

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, p1.props.paddingY),
			PaddingRight = UDim.new(0, p1.props.paddingX)
		}),
		timestamp = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(0, textWidth, 0, textSize),
			Text = p1.props.text,
			TextSize = textSize,
			Font = currentStyle.Font.Body.Font,
			TextColor3 = currentStyle.Theme.TextDefault.Color,
			TextTransparency = currentStyle.Theme.TextDefault.Transparency
		})
	})
end

return v3
