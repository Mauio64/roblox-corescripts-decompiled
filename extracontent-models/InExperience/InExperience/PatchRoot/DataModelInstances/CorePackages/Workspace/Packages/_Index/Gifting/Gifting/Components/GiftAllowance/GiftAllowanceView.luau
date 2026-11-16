local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens

local function GiftAllowanceView(props)
	local v = useTokens()

	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-large size-full-0 auto-y padding-medium stroke-default radius-medium",
			testId = "GiftAllowanceView",
			LayoutOrder = props.LayoutOrder
		},
		{
			RemainingGifts = React.createElement(
				View,
				{ tag = "row align-y-center fill gap-medium auto-y", LayoutOrder = 1 },
				{
					GiftIcon = React.createElement(Icon, {
						name = IconName.GiftBox,
						variant = IconVariant.Regular,
						size = IconSize.Medium,
						style = v.Color.Content.Emphasis,
						LayoutOrder = 1
					}),
					Label = React.createElement(Text, {
						tag = "fill auto-y text-body-medium text-no-wrap text-align-x-left content-emphasis",
						Text = props.remainingGiftsText,
						testId = "gift-allowance-remaining-gifts",
						LayoutOrder = 2
					})
				}
			),
			Expiry = React.createElement(
				View,
				{
					tag = "row align-y-center gap-xsmall auto-xy padding-x-small padding-y-xsmall radius-small bg-shift-200",
					testId = "gift-allowance-expiry-pill",
					LayoutOrder = 2
				},
				{
					ClockIcon = React.createElement(Icon, {
						name = IconName.Clock,
						variant = IconVariant.Filled,
						size = IconSize.XSmall,
						style = v.Color.Content.Emphasis,
						LayoutOrder = 1
					}),
					Label = React.createElement(Text, {
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
