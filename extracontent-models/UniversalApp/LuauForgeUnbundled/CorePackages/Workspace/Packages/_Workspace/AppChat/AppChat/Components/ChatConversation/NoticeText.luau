local TextService = game:GetService("TextService")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

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

function extended.render(p2)
	local v6 = math.max(0, p2.props.maxWidth - (p2.props.margin.left + p2.props.margin.right))

	local vector2 = Vector2.new(v6, 1e999)
	local textSize = TextService:GetTextSize(p2.props.Text, p2.props.TextSize, p2.props.Font, vector2)

	return Roact.createElement("Frame", {
		AnchorPoint = p2.props.AnchorPoint,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = p2.props.LayoutOrder,
		Position = p2.props.Position,
		[Roact.Change.AbsoluteSize] = p2.props[Roact.Change.AbsoluteSize],
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(p2.props.width, UDim.new(0, 0))
	}, {
		Layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = p2.props.HorizontalAlignment
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, p2.props.margin.bottom),
			PaddingRight = UDim.new(0, p2.props.margin.right),
			PaddingLeft = UDim.new(0, p2.props.margin.left),
			PaddingTop = UDim.new(0, p2.props.margin.top)
		}),
		NoticeText = Roact.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = p2.props.Font,
			Text = p2.props.Text,
			TextColor3 = p2.props.TextColor3,
			TextSize = p2.props.TextSize,
			TextTransparency = p2.props.TextTransparency,
			TextWrapped = p2.props.TextWrapped,
			TextXAlignment = p2.props.TextXAlignment,
			TextYAlignment = p2.props.TextYAlignment,
			Size = UDim2.fromOffset(math.ceil(textSize.X), (math.ceil(textSize.Y)))
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v6, 1e999)
			})
		})
	})
end

return extended
