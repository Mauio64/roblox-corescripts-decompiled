local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local shouldShowPriceLabel = itemDetailsUtils.shouldShowPriceLabel
local ButtonVariant = Foundation.Enums.ButtonVariant
require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)

local function BuyActionBar(props)
	local v = useTokens()

	local v2 = React.useMemo(function()
		return shouldShowPriceLabel(props.priceStatus)
	end, { props.priceStatus })

	local createElement = React.createElement
	local view = Foundation.View
	local infoFrame

	if props.priceLabel then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local v3 = {
			PriceDescriptionLabel = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-medium content-emphasis text-truncate-end",
				Text = not v2 and "" or props.priceLabel.leftLabel,
				LayoutOrder = 1
			}),
			RobuxLabel = 0
		}
		local robuxLabel

		if v2 then
			robuxLabel = React.createElement(
				Foundation.View,
				{ tag = "auto-xy row align-x-left align-y-center gap-xsmall", LayoutOrder = 2 },
				{
					PriceText = React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-large content-emphasis text-truncate-end",
						Text = props.priceLabel.priceInRobux,
						LayoutOrder = 2
					}),
					Robux = React.createElement(Foundation.Icon, {
						name = "robux",
						style = v.Color.ActionStandard.Foreground,
						size = Foundation.Enums.IconSize.Small,
						LayoutOrder = 1
					})
				}
			)
		end

		v3.RobuxLabel = robuxLabel
		infoFrame = createElement2(
			view2,
			{
				tag = "size-full-800 row flex-x-between align-y-center gap-small",
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			v3
		)
	end

	return createElement(
		view,
		{
			tag = "size-full col gap-xsmall align-x-center padding-x-large padding-bottom-medium",
			LayoutOrder = 1
		},
		{
			InfoFrame = infoFrame,
			PurchaseButton = React.createElement(Foundation.Button, {
				size = Foundation.Enums.InputSize.Medium,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				width = UDim.new(1, 0),
				text = props.purchaseButtonProps.purchaseButtonText,
				variant = props.purchaseButtonProps.variant,
				isDisabled = props.purchaseButtonProps.isDisabled,
				onActivated = props.purchaseButtonProps.onPurchase,
				LayoutOrder = 2
			})
		}
	)
end

return BuyActionBar
