local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens

local function GiftAllowanceView(props)
	local v5 = useTokens()

	return React.createElement(
		view,
		{
			tag = "row align-y-center gap-large size-full-0 auto-y padding-medium stroke-default radius-medium",
			testId = "GiftAllowanceView",
			LayoutOrder = props.LayoutOrder
		},
		{
			RemainingGifts = React.createElement(
				view,
				{ tag = "row align-y-center fill gap-medium auto-y", LayoutOrder = 1 },
				{
					GiftIcon = React.createElement(icon, {
						name = iconName.GiftBox,
						variant = iconVariant.Regular,
						size = iconSize.Medium,
						style = v5.Color.Content.Emphasis,
						LayoutOrder = 1
					}),
					Label = React.createElement(text, {
						tag = "fill auto-y text-body-medium text-no-wrap text-align-x-left content-emphasis",
						Text = props.remainingGiftsText,
						testId = "gift-allowance-remaining-gifts",
						LayoutOrder = 2
					})
				}
			),
			Expiry = React.createElement(
				view,
				{
					tag = "row align-y-center gap-xsmall auto-xy padding-x-small padding-y-xsmall radius-small bg-shift-200",
					testId = "gift-allowance-expiry-pill",
					LayoutOrder = 2
				},
				{
					ClockIcon = React.createElement(icon, {
						name = iconName.Clock,
						variant = iconVariant.Filled,
						size = iconSize.XSmall,
						style = v5.Color.Content.Emphasis,
						LayoutOrder = 1
					}),
					Label = React.createElement(text, {
						tag = "auto-xy text-caption-medium text-no-wrap content-emphasis",
						Text = props.expiryText,
						testId = "gift-allowance-expiry",
						LayoutOrder = 2
					})
				}
			)
		}
	)
end

return React.memo(GiftAllowanceView)
