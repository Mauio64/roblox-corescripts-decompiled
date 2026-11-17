local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

local function FeatureRow(props)
	return React.createElement(
		View,
		{
			tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y",
			LayoutOrder = props.layoutOrder
		},
		{
			Icon = React.createElement(Icon, { name = props.iconName, size = IconSize.Medium }),
			FeatureText = React.createElement(Text, {
				Text = props.text,
				tag = "size-full-0 auto-y text-body-medium text-align-x-left content-default"
			})
		}
	)
end

return FeatureRow
