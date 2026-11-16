local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").NumberLocalization

local useOpenRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/useOpenRobuxUpsell")

local view = Foundation.View
local text = Foundation.Text
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local orientation = Foundation.Enums.Orientation
local iconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function AmountLine(props)
	local localize = numberLocalization.localize(props.amount, LocalizationService.RobloxLocaleId)
	local v5 = props.isAlert and "text-title-medium content-alert" or "text-body-medium content-default"

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row align-y-center gap-large size-full-0 auto-y"
		},
		{
			Label = React.createElement(view, { LayoutOrder = 1, tag = "fill auto-y" }, {
				Text = React.createElement(text, {
					Text = props.label,
					tag = `auto-xy text-align-x-left {v5}`
				})
			}),
			Amount = React.createElement(view, { LayoutOrder = 2, tag = "auto-xy" }, {
				Text = React.createElement(text, {
					Text = `{getIconRichText(iconName.Robux)} {localize}`,
					RichText = true,
					tag = `auto-xy text-align-x-right {v5}`
				})
			})
		}
	)
end

local function RecentActivityInsufficientRobuxDialog(props)
	local totalPrice = props.totalPrice
	local robuxBalance = props.robuxBalance
	local v5 = math.max(totalPrice - robuxBalance, 0)

	local v6 = useLocalization({
		title = "IAPExperience.InsufficientRobux.Title.InsufficientRobux",
		currentBalance = "IAPExperience.InsufficientRobux.Text.CurrentBalance",
		missingRobux = "IAPExperience.InsufficientRobux.Text.MissingRobux",
		orderTotal = "IAPExperience.PurchasePrompt.Label.TotalPriceV2",
		buyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})

	local v7 = useOpenRobuxUpsell(totalPrice, props.onClose)

	return React.createElement(
		dialog.Root,
		{
			size = dialogSize.Small,
			onClose = props.onClose,
			hasBackdrop = true,
			disablePortal = false
		},
		{
			Title = React.createElement(dialog.Title, {
				LayoutOrder = 1,
				text = v6.title
			}),
			Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				PriceBoxPadding = React.createElement(
					view,
					{ tag = "size-full-0 auto-y padding-xxsmall" },
					{
						PriceBox = React.createElement(
							view,
							{
								tag = "col gap-large size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium"
							},
							{
								BalanceLines = React.createElement(
									view,
									{
										LayoutOrder = 1,
										tag = "col gap-xsmall size-full-0 auto-y"
									},
									{
										CurrentBalance = React.createElement(AmountLine, {
											layoutOrder = 1,
											label = v6.currentBalance,
											amount = robuxBalance
										}),
										MissingRobux = React.createElement(AmountLine, {
											layoutOrder = 2,
											label = v6.missingRobux,
											amount = v5,
											isAlert = true
										})
									}
								),
								OrderTotal = React.createElement(AmountLine, {
									layoutOrder = 2,
									label = v6.orderTotal,
									amount = totalPrice
								})
							}
						)
					}
				)
			}),
			Actions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				orientation = orientation.Horizontal,
				actions = {
					{
						text = v6.buyRobux,
						variant = buttonVariant.Emphasis,
						onActivated = v7
					}
				}
			})
		}
	)
end

return RecentActivityInsufficientRobuxDialog
