local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = require(parent.Core.Style.useStyle)

local function HelperText(props)
	local v = useStyle()

	local captionSmall = v.Tokens.Typography.CaptionSmall
	local v2

	if props.error then
		v2 = v.Tokens.Color.ActionAlert.Foreground
	else
		v2 = v.Tokens.Color.Content.Default
	end

	return React.createElement("TextLabel", {
		Text = props.text,
		TextTransparency = v2.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundTransparency = 1,
		TextColor3 = v2.Color3,
		FontFace = normalizeFontFace(captionSmall.Font),
		TextSize = captionSmall.FontSize,
		LineHeight = captionSmall.LineHeight,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder
	})
end

return HelperText
