local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").GetTextSize
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation").Utility.normalizeFontFace

return function(props)
	local x = getTextSize(props.text, props.fontSize, props.font, Vector2.new(1e999, props.fontSize), {
		addTemporaryPadding = false
	}).X

	local createElement = React.createElement

	local v6 = { LayoutOrder = props.layoutOrder, Size = 0, BackgroundTransparency = 1 }
	local v7 = if props.size then props.size else UDim2.new(0, props.width, 0, props.height)
	v6.Size = v7
	return createElement("Frame", v6, React.createElement("Frame", {
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
