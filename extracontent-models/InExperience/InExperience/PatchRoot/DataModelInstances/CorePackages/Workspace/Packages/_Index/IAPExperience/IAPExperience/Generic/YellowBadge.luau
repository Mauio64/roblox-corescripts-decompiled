local parent = script.Parent.Parent.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local View = Foundation.View
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

return function(props)
	local emphasis = useTokens().LightMode.Content.Emphasis
	local color = Color3.fromRGB(239, 215, 140)

	local createElement = React.createElement
	local v = {
		LayoutOrder = props.LayoutOrder,
		tag = "radius-circle padding-small row gap-xsmall align-y-center align-x-center auto-xy",
		backgroundStyle = { Color3 = color, Transparency = 0 }
	}
	local icon

	if props.Icon then
		icon = React.createElement(Image, {
			LayoutOrder = 1,
			Image = props.Icon,
			imageStyle = emphasis,
			tag = "size-300"
		})
	end

	return createElement(View, v, {
		Icon = icon,
		Text = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.Text,
			textStyle = emphasis,
			tag = "text-caption-small content-emphasis text-align-x-center auto-xy"
		})
	})
end
