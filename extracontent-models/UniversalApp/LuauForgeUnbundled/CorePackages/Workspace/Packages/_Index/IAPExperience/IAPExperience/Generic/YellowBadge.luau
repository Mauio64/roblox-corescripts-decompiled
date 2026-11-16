local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local text = Foundation.Text
local view = Foundation.View
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

return function(props)
	local emphasis = useTokens().LightMode.Content.Emphasis
	local color = Color3.fromRGB(239, 215, 140)

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.LayoutOrder,
		tag = "radius-circle padding-small row gap-xsmall align-y-center align-x-center auto-xy",
		backgroundStyle = { Color3 = color, Transparency = 0 }
	}

	local v8 = if props.Icon then React.createElement(image, {
		LayoutOrder = 1,
		Image = props.Icon,
		imageStyle = emphasis,
		tag = "size-300"
	}) else nil
	return createElement(view, v6, {
		Icon = v8,
		Text = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.Text,
			textStyle = emphasis,
			tag = "text-caption-small content-emphasis text-align-x-center auto-xy"
		})
	})
end
