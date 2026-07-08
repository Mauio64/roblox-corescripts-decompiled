local TextService = game:GetService("TextService")
local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local v4 = Roact.PureComponent:extend("NoticeText")

v4.defaultProps = {
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
	[Roact.Change.AbsoluteSize] = function() -- line: 22
	end,
	margin = {
		top = 0,
		left = 0,
		right = 0,
		bottom = 0
	},
	maxWidth = 0,
	width = UDim.new(1, 0)
}

function v4.render(p1) -- line: 34
	-- upvalues: TextService (copy), Roact (copy)
	local v6 = math.max(0, p1.props.maxWidth - (p1.props.margin.left + p1.props.margin.right))
	local vector2 = Vector2.new(v6, 1e999)
	local TextSize = TextService:GetTextSize(p1.props.Text, p1.props.TextSize, p1.props.Font, vector2)

	return Roact.createElement("Frame", {
		AnchorPoint = p1.props.AnchorPoint,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = p1.props.LayoutOrder,
		Position = p1.props.Position,
		[Roact.Change.AbsoluteSize] = p1.props[Roact.Change.AbsoluteSize],
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(p1.props.width, UDim.new(0, 0))
	}, {
		Layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = p1.props.HorizontalAlignment
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, p1.props.margin.bottom),
			PaddingRight = UDim.new(0, p1.props.margin.right),
			PaddingLeft = UDim.new(0, p1.props.margin.left),
			PaddingTop = UDim.new(0, p1.props.margin.top)
		}),
		NoticeText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = p1.props.Font,
			Text = p1.props.Text,
			TextColor3 = p1.props.TextColor3,
			TextSize = p1.props.TextSize,
			TextTransparency = p1.props.TextTransparency,
			TextWrapped = p1.props.TextWrapped,
			TextXAlignment = p1.props.TextXAlignment,
			TextYAlignment = p1.props.TextYAlignment,
			Size = UDim2.fromOffset(math.ceil(TextSize.X), (math.ceil(TextSize.Y)))
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v6, 1e999)
			})
		})
	})
end

return v4
