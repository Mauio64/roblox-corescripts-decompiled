local parent = script:FindFirstAncestor("AuthCommon").Parent
local React = require(parent.React)
local TextService = game:GetService("TextService")
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

return function(props)
	local x

	if FoundationFontFaceMigration then
		x = GetTextSize(props.text, props.fontSize, props.font, Vector2.new(1e999, props.fontSize), {
			addTemporaryPadding = false
		}).X
	else
		x = TextService:GetTextSize(props.text, props.fontSize, props.font, Vector2.new(1e999, props.fontSize)).X
	end

	local createElement = React.createElement

	local v = { LayoutOrder = props.layoutOrder, Size = 0, BackgroundTransparency = 1 }
	local size

	if props.size then
		size = props.size
	else
		size = UDim2.new(0, props.width, 0, props.height)
	end

	v.Size = size

	local element = React.createElement("Frame", {
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0.5, -x / 2 - props.padding, 0, 1),
		BackgroundTransparency = props.transparency,
		BackgroundColor3 = props.color3
	})

	local element2 = React.createElement("Frame", {
		Position = UDim2.new(0.5, x / 2 + props.padding, 0.5, 0),
		Size = UDim2.new(0.5, -x / 2 - props.padding, 0, 1),
		BackgroundTransparency = props.transparency,
		BackgroundColor3 = props.color3
	})

	local createElement2 = React.createElement
	local v2 = {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Text = props.text,
		TextSize = props.fontSize,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextTransparency = 0,
		TextColor3 = 0,
		BackgroundTransparency = 1
	}
	local font

	if not FoundationFontFaceMigration then
		font = props.font
	end

	v2.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(props.font)
	end

	v2.FontFace = fontFace
	v2.TextXAlignment = Enum.TextXAlignment.Center
	v2.TextYAlignment = Enum.TextYAlignment.Center
	v2.TextTransparency = props.transparency
	v2.TextColor3 = props.color3
	return createElement("Frame", v, element, element2, createElement2("TextLabel", v2))
end
