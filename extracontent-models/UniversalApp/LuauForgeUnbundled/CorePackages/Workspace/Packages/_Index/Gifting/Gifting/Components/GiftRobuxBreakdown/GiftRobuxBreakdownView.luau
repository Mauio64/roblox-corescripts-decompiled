local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local divider = Foundation.Divider
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local function PriceLine(props)
	local line = props.line
	local v5 = props.isTotal and "fill auto-y text-title-small text-align-x-left content-emphasis"
		or "fill auto-y text-body-small text-align-x-left content-emphasis"

	local v6 = props.isTotal and "auto-xy text-title-small content-emphasis"
		or "auto-xy text-body-small content-emphasis"

	local createElement = React.createElement
	local v8 = {
		tag = "row align-y-center size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder
	}
	local v9 = {
		Label = React.createElement(text, {
			tag = v5,
			Text = line.label,
			LayoutOrder = 1
		}),
		Amount = 0
	}

	local createElement2 = React.createElement

	local v12 = if line.amountPrefix then React.createElement(text, {
		tag = v6,
		Text = line.amountPrefix,
		LayoutOrder = 1
	}) else nil
	v9.Amount = createElement2(view, {
		tag = "row align-y-center gap-xsmall auto-xy",
		LayoutOrder = 2
	}, {
		Prefix = v12,
		RobuxIcon = React.createElement(icon, {
			name = iconName.Robux,
			size = iconSize.XSmall,
			LayoutOrder = 2
		}),
		Value = React.createElement(text, {
			tag = v6,
			Text = line.amountText,
			LayoutOrder = 3
		})
	})
	return createElement(view, v8, v9)
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

	local v7 = {
		Header = React.createElement(view, {
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-y-small radius-medium",
			onActivated = props.onToggle,
			stateLayer = { affordance = stateLayerAffordance.Background },
			testId = "gift-robux-breakdown-toggle",
			LayoutOrder = 1
		}, {
			PlusIcon = React.createElement(icon, {
				name = iconName.RobloxPlus,
				size = iconSize.Medium,
				LayoutOrder = 1
			}),
			Summary = React.createElement(
				view,
				{ tag = "row align-y-center fill gap-xxsmall auto-y", LayoutOrder = 2 },
				{
					Leading = React.createElement(text, {
						tag = "auto-xy text-body-medium text-align-x-left content-emphasis",
						Text = props.summaryLeadingText,
						testId = "gift-robux-breakdown-summary-leading",
						LayoutOrder = 1
					}),
					Amount = React.createElement(
						view,
						{
							tag = "row align-y-center gap-xxsmall auto-xy",
							LayoutOrder = 2
						},
						{
							RobuxIcon = React.createElement(icon, {
								name = iconName.Robux,
								size = iconSize.Small,
								LayoutOrder = 1
							}),
							Value = React.createElement(text, {
								tag = "auto-xy text-title-medium text-no-wrap content-emphasis",
								Text = props.summaryAmountText,
								testId = "gift-robux-breakdown-summary-amount",
								LayoutOrder = 2
							})
						}
					),
					Trailing = React.createElement(text, {
						tag = "auto-xy text-body-medium text-align-x-left content-emphasis",
						Text = props.summaryTrailingText,
						testId = "gift-robux-breakdown-summary-trailing",
						LayoutOrder = 3
					})
				}
			),
			Chevron = React.createElement(icon, {
				name = iconName.ChevronLargeDown,
				size = iconSize.Medium,
				Rotation = props.isExpanded and 180 or 0,
				testId = "gift-robux-breakdown-chevron",
				LayoutOrder = 3
			})
		}),
		Content = 0
	}

	local v8 = if props.isExpanded then React.createElement(
		view,
		{
			tag = "col gap-small size-full-0 auto-y padding-x-medium padding-bottom-medium padding-top-xsmall",
			testId = "gift-robux-breakdown-content",
			LayoutOrder = 2
		},
		{
			Rows = React.createElement(
				view,
				{ tag = "col gap-xxsmall size-full-0 auto-y", LayoutOrder = 1 },
				{
					Subtotal = React.createElement(PriceLine, {
						line = props.subtotal,
						LayoutOrder = 1
					}),
					Discounts = React.createElement(
						view,
						{ tag = "col gap-xxsmall size-full-0 auto-y", LayoutOrder = 2 },
						children
					)
				}
			),
			Divider = React.createElement(divider, { LayoutOrder = 2 }),
			Total = React.createElement(PriceLine, {
				line = props.total,
				isTotal = true,
				LayoutOrder = 3
			})
		}
	) else nil
	v7.Content = v8
	return createElement(
		view,
		{
			tag = "col size-full-0 auto-y stroke-default radius-medium clip",
			testId = "GiftRobuxBreakdownView"
		},
		v7
	)
end

return React.memo(GiftRobuxBreakdownView)
