local Parent = script:FindFirstAncestor("AppChat").Parent
local Text = require(Parent.AppCommonLib).Text
local Roact = require(Parent.Roact)
local memoize = require(Parent.AppCommonLib).memoize
local withStyle = require(Parent.UIBlox).Style.withStyle
local v6 = Roact.PureComponent:extend("SystemMessage")

v6.defaultProps = {
	LayoutOrder = nil,
	Text = "PLACEHOLDER This message could not be displayed",
	maxWidth = 250
}

function v6.init(p1) -- line: 25
	-- upvalues: memoize (copy), Text (copy)
	p1.calculateSize = memoize(function(p2, p3, p4, p5) -- line: 26
		-- upvalues: Text (copy)
		return Text.GetTextBounds(p2, p4, p5, Vector2.new(p3, 1000))
	end)
end
function v6.render(p6) -- line: 37
	-- upvalues: withStyle (copy), Roact (copy)
	return withStyle(function(p7) -- line: 38
		-- upvalues: p6 (copy), Roact (copy)
		local CaptionBody = p7.Font.CaptionBody
		local v15 = p7.Font.BaseSize * CaptionBody.RelativeSize
		local v16 = p6.calculateSize(p6.props.Text, p6.props.maxWidth, CaptionBody.Font, v15)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p6.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 30 + v16.Y + 8)
		}, {
			UiListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 20)
			}),
			GreyBox = Roact.createElement("ImageLabel", {
				BorderSizePixel = 0,
				Image = "rbxasset://textures/ui/LuaChat/9-slice/system-message.png",
				ImageTransparency = 1,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(0, math.min(p6.props.maxWidth, v16.X) + 12, 0, v16.Y + 8),
				SliceCenter = Rect.new(3, 3, 4, 4)
			}, {
				SystemText = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					TextWrapped = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Font = CaptionBody.Font,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 1, 0),
					Text = p6.props.Text,
					TextColor3 = p7.Theme.TextDefault.Color,
					TextSize = v15,
					TextTransparency = p7.Theme.TextDefault.Transparency
				})
			})
		})
	end)
end

return v6
