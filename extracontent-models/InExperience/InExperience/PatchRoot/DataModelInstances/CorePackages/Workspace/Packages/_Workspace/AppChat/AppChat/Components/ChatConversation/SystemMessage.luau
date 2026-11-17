local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("SystemMessage")
extended.defaultProps = {
	LayoutOrder = nil,
	Text = "PLACEHOLDER This message could not be displayed",
	maxWidth = 250
}

function extended:init()
	self.calculateSize = memoize(function(p, p2, p3, p4)
		return GetTextSize(p, p4, p3, Vector2.new(p2, 1000))
	end)
end

function extended.render(p)
	return withStyle(function(props)
		local captionBody = props.Font.CaptionBody
		local textSize = props.Font.BaseSize * captionBody.RelativeSize

		local size = p.calculateSize(p.props.Text, p.props.maxWidth, props.Tokens.Typography.BodySmall.Font, textSize)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 30 + size.Y + 8)
		}, {
			UiListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 20) }),
			GreyBox = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BorderSizePixel = 0,
				Image = "rbxasset://textures/ui/LuaChat/9-slice/system-message.png",
				ImageTransparency = 1,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(0, math.min(p.props.maxWidth, size.X) + 12, 0, size.Y + 8),
				SliceCenter = Rect.new(3, 3, 4, 4)
			}, {
				SystemText = Roact.createElement("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 1, 0),
					Text = p.props.Text,
					TextColor3 = props.Theme.TextDefault.Color,
					TextSize = textSize,
					TextTransparency = props.Theme.TextDefault.Transparency,
					TextWrapped = true
				})
			})
		})
	end)
end

return extended
