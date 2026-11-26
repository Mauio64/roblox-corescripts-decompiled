local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local useTokens = Foundation.Hooks.useTokens
local shouldShowPriceLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils").shouldShowPriceLabel
local buttonVariant = Foundation.Enums.ButtonVariant
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")

local function BuyActionBar(props)
	local v5 = useTokens()

	local v6 = React.useMemo(function()
		return shouldShowPriceLabel(props.priceStatus)
	end, { props.priceStatus })

	local createElement = React.createElement
	local view = Foundation.View
	local v9

	if props.priceLabel then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local v11 = {
			PriceDescriptionLabel = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-medium content-emphasis text-truncate-end",
				Text = not v6 and "" or props.priceLabel.leftLabel,
				LayoutOrder = 1
			}),
			RobuxLabel = 0
		}

		local v12 = if v6 then React.createElement(
			Foundation.View,
			{
				tag = "auto-xy row align-x-left align-y-center gap-xsmall",
				LayoutOrder = 2
			},
			{
				PriceText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-body-large content-emphasis text-truncate-end",
					Text = props.priceLabel.priceInRobux,
					LayoutOrder = 2
				}),
				Robux = React.createElement(Foundation.Icon, {
					name = "robux",
					style = v5.Color.ActionStandard.Foreground,
					size = Foundation.Enums.IconSize.Small,
					LayoutOrder = 1
				})
			}
		) else nil
		v11.RobuxLabel = v12
		v9 = createElement2(
			view2,
			{
				tag = "size-full-800 row flex-x-between align-y-center gap-small",
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			v11
		)
	end

	return createElement(
		view,
		{
			tag = "size-full col gap-xsmall align-x-center padding-x-large padding-bottom-medium",
			LayoutOrder = 1
		},
		{
			InfoFrame = v9,
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
