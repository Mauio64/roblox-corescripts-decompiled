local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").NumberLocalization

local view = Foundation.View
local text = Foundation.Text
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local orientation = Foundation.Enums.Orientation
local iconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function RecentActivityPurchaseConfirmationDialog(props)
	local v5 = useLocalization({
		buyTitle = "IAPExperience.PurchasePrompt.Header.BuyAvatar",
		buyAction = "IAPExperience.PurchasePrompt.Action.Buy",
		totalPrice = "IAPExperience.PurchasePrompt.Label.TotalPriceV2"
	})

	local v6 = React.useMemo(function()
		local localize = numberLocalization.localize(props.totalPrice, LocalizationService.RobloxLocaleId)
		return `{getIconRichText(iconName.Robux)} {localize}`
	end, { props.totalPrice, LocalizationService.RobloxLocaleId })

	local v7 = React.useCallback(function()
		if props.isPurchasing then
			return
		end

		props.onCancel()
	end, { props.isPurchasing, props.onCancel })

	return React.createElement(
		dialog.Root,
		{
			size = dialogSize.Small,
			onClose = v7,
			hasBackdrop = true,
			disablePortal = false
		},
		{
			DialogTitle = React.createElement(dialog.Title, {
				LayoutOrder = 1,
				text = v5.buyTitle
			}),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				PriceTotal = React.createElement(
					view,
					{
						tag = "size-full-1300 padding-bottom-large padding-left-xxsmall padding-right-xxsmall padding-top-small"
					},
					{
						BorderContainer = React.createElement(
							view,
							{
								tag = "row align-x-center align-y-center auto-xy padding-x-large padding-y-xsmall stroke-default radius-medium"
							},
							{
								LeftSide = React.createElement(
									view,
									{
										LayoutOrder = 1,
										tag = "row align-y-center gap-small padding-y-xsmall",
										Size = UDim2.new(0.5, 0, 1, 0)
									},
									{
										Label = React.createElement(text, {
											LayoutOrder = 1,
											Text = v5.totalPrice,
											tag = "auto-xy padding-y-xsmall text-title-medium text-align-x-left content-default"
										})
									}
								),
								RightSide = React.createElement(
									view,
									{
										LayoutOrder = 2,
										tag = "row align-x-right align-y-center gap-large padding-y-xsmall",
										Size = UDim2.new(0.5, 0, 1, 0)
									},
									{
										Price = React.createElement(text, {
											LayoutOrder = 1,
											Text = v6,
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
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				orientation = orientation.Horizontal,
				actions = {
					{
						text = v5.buyAction,
						variant = buttonVariant.Emphasis,
						onActivated = props.onConfirm
					}
				}
			})
		}
	)
end

return RecentActivityPurchaseConfirmationDialog
