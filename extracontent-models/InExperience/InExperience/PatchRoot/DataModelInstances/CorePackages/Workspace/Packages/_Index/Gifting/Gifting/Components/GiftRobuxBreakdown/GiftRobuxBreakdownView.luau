local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Divider = Foundation.Divider
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local function PriceLine(props)
	local line = props.line
	local tag = props.isTotal and "fill auto-y text-title-small text-align-x-left content-emphasis"
		or "fill auto-y text-body-small text-align-x-left content-emphasis"

	local tag2 = props.isTotal and "auto-xy text-title-small content-emphasis"
		or "auto-xy text-body-small content-emphasis"

	local createElement = React.createElement
	local v = { tag = "row align-y-center size-full-0 auto-y", LayoutOrder = props.LayoutOrder }
	local v2 = {
		Label = React.createElement(Text, { tag = tag, Text = line.label, LayoutOrder = 1 }),
		Amount = 0
	}

	local createElement2 = React.createElement
	local prefix

	if line.amountPrefix then
		prefix = React.createElement(Text, { tag = tag2, Text = line.amountPrefix, LayoutOrder = 1 })
	end

	v2.Amount = createElement2(View, {
		tag = "row align-y-center gap-xsmall auto-xy",
		LayoutOrder = 2
	}, {
		Prefix = prefix,
		RobuxIcon = React.createElement(Icon, {
			name = IconName.Robux,
			size = IconSize.XSmall,
			LayoutOrder = 2
		}),
		Value = React.createElement(Text, { tag = tag2, Text = line.amountText, LayoutOrder = 3 })
	})
	return createElement(View, v, v2)
end

local function GiftRobuxBreakdownView(props)
	local children = {}

	for k, discount in props.discounts do
		children[`Discount-{k}`] = React.createElement(PriceLine, {
			line = discount,
			LayoutOrder = k + 1
		})
	end

	local createElement = React.createElement

	local v = {
		Header = React.createElement(View, {
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-y-small radius-medium",
			onActivated = props.onToggle,
			stateLayer = { affordance = StateLayerAffordance.Background },
			testId = "gift-robux-breakdown-toggle",
			LayoutOrder = 1
		}, {
			PlusIcon = React.createElement(Icon, {
				name = IconName.RobloxPlus,
				size = IconSize.Medium,
				LayoutOrder = 1
			}),
			Summary = React.createElement(
				View,
				{ tag = "row align-y-center fill gap-xxsmall auto-y", LayoutOrder = 2 },
				{
					Leading = React.createElement(Text, {
						tag = "auto-xy text-body-medium text-align-x-left content-emphasis",
						Text = props.summaryLeadingText,
						testId = "gift-robux-breakdown-summary-leading",
						LayoutOrder = 1
					}),
					Amount = React.createElement(
						View,
						{ tag = "row align-y-center gap-xxsmall auto-xy", LayoutOrder = 2 },
						{
							RobuxIcon = React.createElement(Icon, {
								name = IconName.Robux,
								size = IconSize.Small,
								LayoutOrder = 1
							}),
							Value = React.createElement(Text, {
								tag = "auto-xy text-title-medium text-no-wrap content-emphasis",
								Text = props.summaryAmountText,
								testId = "gift-robux-breakdown-summary-amount",
								LayoutOrder = 2
							})
						}
					),
					Trailing = React.createElement(Text, {
						tag = "auto-xy text-body-medium text-align-x-left content-emphasis",
						Text = props.summaryTrailingText,
						testId = "gift-robux-breakdown-summary-trailing",
						LayoutOrder = 3
					})
				}
			),
			Chevron = React.createElement(Icon, {
				name = IconName.ChevronLargeDown,
				size = IconSize.Medium,
				Rotation = props.isExpanded and 180 or 0,
				testId = "gift-robux-breakdown-chevron",
				LayoutOrder = 3
			})
		}),
		Content = 0
	}
	local content

	if props.isExpanded then
		content = React.createElement(
			View,
			{
				tag = "col gap-small size-full-0 auto-y padding-x-medium padding-bottom-medium padding-top-xsmall",
				testId = "gift-robux-breakdown-content",
				LayoutOrder = 2
			},
			{
				Rows = React.createElement(View, {
					tag = "col gap-xxsmall size-full-0 auto-y",
					LayoutOrder = 1
				}, {
					Subtotal = React.createElement(PriceLine, {
						line = props.subtotal,
						LayoutOrder = 1
					}),
					Discounts = React.createElement(
						View,
						{ tag = "col gap-xxsmall size-full-0 auto-y", LayoutOrder = 2 },
						children
					)
				}),
				Divider = React.createElement(Divider, { LayoutOrder = 2 }),
				Total = React.createElement(PriceLine, {
					line = props.total,
					isTotal = true,
					LayoutOrder = 3
				})
			}
		)
	end

	v.Content = content
	return createElement(
		View,
		{
			tag = "col size-full-0 auto-y stroke-default radius-medium clip",
			testId = "GiftRobuxBreakdownView"
		},
		v
	)
end

return React.memo(GiftRobuxBreakdownView)
