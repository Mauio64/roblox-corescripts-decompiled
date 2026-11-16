local TextService = game:GetService("TextService")
local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)

local extended = Roact.PureComponent:extend("NoticeText")
extended.defaultProps = {
	AnchorPoint = Vector2.new(0, 0),
	Font = Enum.Font.Gotham,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	LayoutOrder = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Text = "PLACEHOLDER Not everyone in this chat can see your message.",
	TextColor3 = nil,
	TextSize = 17,
	TextTransparency = nil,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	[Roact.Change.AbsoluteSize] = function() end,
	margin = { top = 0, left = 0, right = 0, bottom = 0 },
	maxWidth = 0,
	width = UDim.new(1, 0)
}

function extended.render(p)
	local v = math.max(0, p.props.maxWidth - (p.props.margin.left + p.props.margin.right))

	local vector2 = Vector2.new(v, 1e999)
	local textSize = TextService:GetTextSize(p.props.Text, p.props.TextSize, p.props.Font, vector2)

	return Roact.createElement("Frame", {
		AnchorPoint = p.props.AnchorPoint,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = p.props.LayoutOrder,
		Position = p.props.Position,
		[Roact.Change.AbsoluteSize] = p.props[Roact.Change.AbsoluteSize],
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(p.props.width, UDim.new(0, 0))
	}, {
		Layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = p.props.HorizontalAlignment
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, p.props.margin.bottom),
			PaddingRight = UDim.new(0, p.props.margin.right),
			PaddingLeft = UDim.new(0, p.props.margin.left),
			PaddingTop = UDim.new(0, p.props.margin.top)
		}),
		NoticeText = Roact.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = p.props.Font,
			Text = p.props.Text,
			TextColor3 = p.props.TextColor3,
			TextSize = p.props.TextSize,
			TextTransparency = p.props.TextTransparency,
			TextWrapped = p.props.TextWrapped,
			TextXAlignment = p.props.TextXAlignment,
			TextYAlignment = p.props.TextYAlignment,
			Size = UDim2.fromOffset(math.ceil(textSize.X), (math.ceil(textSize.Y)))
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v, 1e999)
			})
		})
	})
end

return extended
