local parent = script.Parent.Parent.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local View = Foundation.View
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

return function(props)
	local createElement = React.createElement
	local v = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-center align-y-center gap-xsmall size-600 auto-x padding-x-small radius-circle bg-shift-300"
	}
	local icon

	if props.iconName then
		icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = props.iconName,
			size = IconSize.XSmall,
			tag = "content-emphasis"
		})
	end

	return createElement(View, v, {
		Icon = icon,
		Text = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.Text,
			tag = "auto-xy text-caption-small text-align-x-center content-emphasis"
		})
	})
end
