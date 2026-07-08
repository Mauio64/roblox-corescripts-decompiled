local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)
local useStyle = require(ParentParentParent.Core.Style.useStyle)

require(ParentParent.Style.StyleTypes)
require(ParentParent.Style.Fonts)

local FooterFrame = require(scriptParent.FooterFrame)

local function getStyleProps(t1: {[any]: any}?, p1) -- line: 34
	local v12 = t1 or {}

	return {
		cornerRadius = v12.cornerRadius,
		textColor = v12.textColor or p1.Theme.TextMuted,
		backgroundColor = v12.backgroundColor,
		textXAlignment = v12.textXAlignment or Enum.TextXAlignment.Left,
		textFont = v12.textFont or p1.Font.CaptionBody
	}
end
local function TextFooter(p2) -- line: 45
	-- upvalues: useStyle (copy), getStyleProps (copy), React (copy), FooterFrame (copy)
	local v14 = useStyle()
	local Font = v14.Font
	local v16 = getStyleProps(p2.styleProps, v14)
	local cornerRadius = v16.cornerRadius
	local textColor = v16.textColor
	local backgroundColor = v16.backgroundColor
	local textXAlignment = v16.textXAlignment
	local textFont = v16.textFont

	return React.createElement(FooterFrame, p2, {
		Text = React.createElement("TextLabel", {
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = if not backgroundColor then nil else backgroundColor.Color,
			BackgroundTransparency = not backgroundColor and 1 or backgroundColor.Transparency,
			Text = p2.text,
			TextXAlignment = textXAlignment,
			TextYAlignment = Enum.TextYAlignment.Center,
			Font = textFont.Font,
			TextSize = Font.BaseSize * textFont.RelativeSize,
			TextColor3 = textColor.Color,
			TextTransparency = textColor.Transparency,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UICorner = if not cornerRadius then nil else React.createElement("UICorner", {
				CornerRadius = UDim.new(0, cornerRadius)
			})
		})
	})
end

return TextFooter
