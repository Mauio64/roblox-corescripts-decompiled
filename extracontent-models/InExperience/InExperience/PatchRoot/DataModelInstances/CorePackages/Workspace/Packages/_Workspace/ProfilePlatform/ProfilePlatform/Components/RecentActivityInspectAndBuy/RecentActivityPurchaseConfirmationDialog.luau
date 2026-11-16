local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Localization2 = require(parent.Localization)
local NumberLocalization = Localization2.NumberLocalization

local View = Foundation.View
local Text = Foundation.Text
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Orientation = Foundation.Enums.Orientation
local IconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function RecentActivityPurchaseConfirmationDialog(props)
	local v = useLocalization({
		buyTitle = "IAPExperience.PurchasePrompt.Header.BuyAvatar",
		buyAction = "IAPExperience.PurchasePrompt.Action.Buy",
		totalPrice = "IAPExperience.PurchasePrompt.Label.TotalPriceV2"
	})

	local text = React.useMemo(function()
		local localize = NumberLocalization.localize(props.totalPrice, LocalizationService.RobloxLocaleId)
		return `{getIconRichText(IconName.Robux)} {localize}`
	end, { props.totalPrice, LocalizationService.RobloxLocaleId })

	local onClose = React.useCallback(function()
		if props.isPurchasing then
			return
		end

		props.onCancel()
	end, { props.isPurchasing, props.onCancel })

	return React.createElement(
		Dialog.Root,
		{ size = DialogSize.Small, onClose = onClose, hasBackdrop = true, disablePortal = false },
		{
			DialogTitle = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v.buyTitle }),
			DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				PriceTotal = React.createElement(
					View,
					{
						tag = "size-full-1300 padding-bottom-large padding-left-xxsmall padding-right-xxsmall padding-top-small"
					},
					{
						BorderContainer = React.createElement(
							View,
							{
								tag = "row align-x-center align-y-center auto-xy padding-x-large padding-y-xsmall stroke-default radius-medium"
							},
							{
								LeftSide = React.createElement(
									View,
									{
										LayoutOrder = 1,
										tag = "row align-y-center gap-small padding-y-xsmall",
										Size = UDim2.new(0.5, 0, 1, 0)
									},
									{
										Label = React.createElement(Text, {
											LayoutOrder = 1,
											Text = v.totalPrice,
											tag = "auto-xy padding-y-xsmall text-title-medium text-align-x-left content-default"
										})
									}
								),
								RightSide = React.createElement(
									View,
									{
										LayoutOrder = 2,
										tag = "row align-x-right align-y-center gap-large padding-y-xsmall",
										Size = UDim2.new(0.5, 0, 1, 0)
									},
									{
										Price = React.createElement(Text, {
											LayoutOrder = 1,
											Text = text,
											tag = "auto-xy padding-y-xsmall text-title-medium text-align-x-right content-emphasis",
											RichText = true
										})
									}
								)
							}
						)
					}
				)
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				orientation = Orientation.Horizontal,
				actions = {
					{
						text = v.buyAction,
						variant = ButtonVariant.Emphasis,
						onActivated = props.onConfirm
					}
				}
			})
		}
	)
end

return RecentActivityPurchaseConfirmationDialog
