local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local text = Foundation.Text
local view = Foundation.View
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize

return function(props)
	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-center align-y-center gap-xsmall size-600 auto-x padding-x-small radius-circle bg-shift-300"
	}

	local v8 = if props.iconName then React.createElement(icon, {
		LayoutOrder = 1,
		name = props.iconName,
		size = iconSize.XSmall,
		tag = "content-emphasis"
	}) else nil
	return createElement(view, v6, {
		Icon = v8,
		Text = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.Text,
			tag = "auto-xy text-caption-small text-align-x-center content-emphasis"
		})
	})
end
