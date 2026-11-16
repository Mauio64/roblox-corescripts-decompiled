local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Localization2 = require(parent.Localization)
local NumberLocalization = Localization2.NumberLocalization

local useOpenRobuxUpsell = require(ProfilePlatform.Components.InspectAvatar.useOpenRobuxUpsell)

local View = Foundation.View
local Text = Foundation.Text
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Orientation = Foundation.Enums.Orientation
local IconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function AmountLine(props)
	local localize = NumberLocalization.localize(props.amount, LocalizationService.RobloxLocaleId)
	local v = props.isAlert and "text-title-medium content-alert" or "text-body-medium content-default"

	return React.createElement(
		View,
		{ LayoutOrder = props.layoutOrder, tag = "row align-y-center gap-large size-full-0 auto-y" },
		{
			Label = React.createElement(View, { LayoutOrder = 1, tag = "fill auto-y" }, {
				Text = React.createElement(Text, {
					Text = props.label,
					tag = `auto-xy text-align-x-left {v}`
				})
			}),
			Amount = React.createElement(View, { LayoutOrder = 2, tag = "auto-xy" }, {
				Text = React.createElement(Text, {
					Text = `{getIconRichText(IconName.Robux)} {localize}`,
					RichText = true,
					tag = `auto-xy text-align-x-right {v}`
				})
			})
		}
	)
end

local function RecentActivityInsufficientRobuxDialog(props)
	local totalPrice = props.totalPrice
	local robuxBalance = props.robuxBalance
	local amount = math.max(totalPrice - robuxBalance, 0)

	local v = useLocalization({
		title = "IAPExperience.InsufficientRobux.Title.InsufficientRobux",
		currentBalance = "IAPExperience.InsufficientRobux.Text.CurrentBalance",
		missingRobux = "IAPExperience.InsufficientRobux.Text.MissingRobux",
		orderTotal = "IAPExperience.PurchasePrompt.Label.TotalPriceV2",
		buyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})

	local onActivated = useOpenRobuxUpsell(totalPrice, props.onClose)

	return React.createElement(
		Dialog.Root,
		{
			size = DialogSize.Small,
			onClose = props.onClose,
			hasBackdrop = true,
			disablePortal = false
		},
		{
			Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v.title }),
			Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				PriceBoxPadding = React.createElement(View, {
					tag = "size-full-0 auto-y padding-xxsmall"
				}, {
					PriceBox = React.createElement(
						View,
						{
							tag = "col gap-large size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium"
						},
						{
							BalanceLines = React.createElement(
								View,
								{ LayoutOrder = 1, tag = "col gap-xsmall size-full-0 auto-y" },
								{
									CurrentBalance = React.createElement(AmountLine, {
										layoutOrder = 1,
										label = v.currentBalance,
										amount = robuxBalance
									}),
									MissingRobux = React.createElement(AmountLine, {
										layoutOrder = 2,
										label = v.missingRobux,
										amount = amount,
										isAlert = true
									})
								}
							),
							OrderTotal = React.createElement(AmountLine, {
								layoutOrder = 2,
								label = v.orderTotal,
								amount = totalPrice
							})
						}
					)
				})
			}),
			Actions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				orientation = Orientation.Horizontal,
				actions = {
					{
						text = v.buyRobux,
						variant = ButtonVariant.Emphasis,
						onActivated = onActivated
					}
				}
			})
		}
	)
end

return RecentActivityInsufficientRobuxDialog
