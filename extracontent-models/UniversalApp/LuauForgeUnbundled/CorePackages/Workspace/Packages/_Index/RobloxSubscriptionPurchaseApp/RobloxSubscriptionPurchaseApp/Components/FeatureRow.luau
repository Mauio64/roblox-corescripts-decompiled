local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize

local function FeatureRow(props)
	return React.createElement(
		view,
		{
			tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y",
			LayoutOrder = props.layoutOrder
		},
		{
			Icon = React.createElement(icon, {
				name = props.iconName,
				size = iconSize.Medium
			}),
			FeatureText = React.createElement(text, {
				Text = props.text,
				tag = "size-full-0 auto-y text-body-medium text-align-x-left content-default"
			})
		}
	)
end

return FeatureRow
