local parent = script:FindFirstAncestor("AuthCommon").Parent
local React = require(parent.React)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

return function(props)
	local x = GetTextSize(props.text, props.fontSize, props.font, Vector2.new(1e999, props.fontSize), {
		addTemporaryPadding = false
	}).X

	local createElement = React.createElement

	local v = { LayoutOrder = props.layoutOrder, Size = 0, BackgroundTransparency = 1 }
	local size

	if props.size then
		size = props.size
	else
		size = UDim2.new(0, props.width, 0, props.height)
	end

	v.Size = size
	return createElement("Frame", v, React.createElement("Frame", {
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0.5, -x / 2 - props.padding, 0, 1),
		BackgroundTransparency = props.transparency,
		BackgroundColor3 = props.color3
	}), React.createElement("Frame", {
		Position = UDim2.new(0.5, x / 2 + props.padding, 0.5, 0),
		Size = UDim2.new(0.5, -x / 2 - props.padding, 0, 1),
		BackgroundTransparency = props.transparency,
		BackgroundColor3 = props.color3
	}), React.createElement("TextLabel", {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Text = props.text,
		TextSize = props.fontSize,
		FontFace = normalizeFontFace(props.font),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTransparency = props.transparency,
		TextColor3 = props.color3,
		BackgroundTransparency = 1
	}))
end
