local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local React = require(parent4.React)
local Foundation = require(parent4.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = require(parent3.Core.Style.useStyle)
require(parent2.Style.StyleTypes)
require(parent2.Style.Fonts)

local FooterFrame = require(parent.FooterFrame)

local function getStyleProps(styleProps, p)
	local v = styleProps or {}
	return {
		cornerRadius = v.cornerRadius,
		textColor = v.textColor or p.Theme.TextMuted,
		backgroundColor = v.backgroundColor,
		textXAlignment = v.textXAlignment or Enum.TextXAlignment.Left,
		textFont = v.textFont or p.Font.CaptionBody
	}
end

local function TextFooter(p)
	local v = useStyle()
	local font = v.Font

	local styleProps = getStyleProps(p.styleProps, v)
	local cornerRadius = styleProps.cornerRadius
	local textColor = styleProps.textColor
	local backgroundColor = styleProps.backgroundColor
	local textXAlignment = styleProps.textXAlignment
	local textFont = styleProps.textFont

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v2 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextTruncate = 0
	}
	local backgroundColor2

	if backgroundColor then
		backgroundColor2 = backgroundColor.Color
	end

	v2.BackgroundColor3 = backgroundColor2
	v2.BackgroundTransparency = not backgroundColor and 1 or backgroundColor.Transparency

	v2.Text = p.text
	v2.TextXAlignment = textXAlignment
	v2.TextYAlignment = Enum.TextYAlignment.Center
	v2.FontFace = normalizeFontFace(textFont.Font)
	v2.TextSize = font.BaseSize * textFont.RelativeSize
	v2.TextColor3 = textColor.Color
	v2.TextTransparency = textColor.Transparency
	v2.TextTruncate = Enum.TextTruncate.AtEnd
	local uiCorner

	if cornerRadius then
		uiCorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, cornerRadius) })
	end

	return createElement(FooterFrame, p, {
		Text = createElement2("TextLabel", v2, { UICorner = uiCorner })
	})
end

return TextFooter
