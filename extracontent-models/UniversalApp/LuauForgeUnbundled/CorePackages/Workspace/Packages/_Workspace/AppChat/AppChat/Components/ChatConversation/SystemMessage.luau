local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").memoize
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("SystemMessage")
extended.defaultProps = {
	LayoutOrder = nil,
	Text = "PLACEHOLDER This message could not be displayed",
	maxWidth = 250
}

function extended:init()
	self.calculateSize = memoize(function(p3, p4, p5, p6)
		return getTextSize(p3, p6, p5, Vector2.new(p4, 1000))
	end)
end

function extended.render(p2)
	return withStyle(function(props)
		local captionBody = props.Font.CaptionBody
		local v5 = props.Font.BaseSize * captionBody.RelativeSize

		local size = p2.calculateSize(
			p2.props.Text,
			p2.props.maxWidth,
			props.Tokens.Typography.BodySmall.Font,
			v5
		)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p2.props.LayoutOrder,
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
				Size = UDim2.new(0, math.min(p2.props.maxWidth, size.X) + 12, 0, size.Y + 8),
				SliceCenter = Rect.new(3, 3, 4, 4)
			}, {
				SystemText = Roact.createElement("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 1, 0),
					Text = p2.props.Text,
					TextColor3 = props.Theme.TextDefault.Color,
					TextSize = v5,
					TextTransparency = props.Theme.TextDefault.Transparency,
					TextWrapped = true
				})
			})
		})
	end)
end

return extended
