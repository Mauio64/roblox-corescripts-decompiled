local module = require("@luauforge/bundled/hHr")
local module2 = require("@luauforge/bundled/hHu")

local linkedText = require("@luauforge/bundled/hIt").LinkedText

local button = module.Button
local checkbox = module.Checkbox
local dialog = module.Dialog
local view = module.View
local buttonVariant = module.Enums.ButtonVariant
local dialogSize = module.Enums.DialogSize
local inputSize = module.Enums.InputSize
local useTokens = module.Hooks.useTokens

local function FirstTimePurchaseConsentDialogView(props)
	local v5 = useTokens()

	return module2.createElement(dialog.Root, {
		size = dialogSize.Small,
		hasBackdrop = true,
		disablePortal = false,
		ref = props.focusRef,
		testId = "first-time-purchase-consent-dialog"
	}, {
		Title = module2.createElement(dialog.Title, { text = props.title }),
		Body = module2.createElement(view, {
			LayoutOrder = 2,
			tag = "col gap-large size-full-0 auto-y"
		}, {
			Description = module2.createElement(linkedText, {
				LayoutOrder = 1,
				text = props.description,
				onLinkActivated = props.onLearnMoreActivated,
				fontStyle = v5.Typography.BodyMedium,
				textStyle = v5.Color.Content.Default,
				linkTextStyle = v5.Color.Content.Default,
				testId = "first-time-purchase-consent-description"
			}),
			Confirmation = module2.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "row align-y-top gap-medium size-full-0 auto-y"
				},
				{
					Checkbox = module2.createElement(checkbox, {
						LayoutOrder = 1,
						isChecked = props.isConsentChecked,
						onActivated = props.onCheckboxActivated,
						label = "",
						size = inputSize.Medium,
						testId = "first-time-purchase-consent-checkbox"
					}),
					Text = module2.createElement(view, {
						LayoutOrder = 2,
						tag = "fill auto-y"
					}, {
						Linked = module2.createElement(linkedText, {
							text = props.confirmation,
							onLinkActivated = props.onTermsOfUseActivated,
							fontStyle = v5.Typography.BodySmall,
							textStyle = v5.Color.Content.Emphasis,
							linkTextStyle = v5.Color.Content.Emphasis,
							testId = "first-time-purchase-consent-confirmation"
						})
					})
				}
			),
			Buttons = module2.createElement(
				view,
				{ LayoutOrder = 3, tag = "col gap-small size-full-0 auto-y" },
				{
					Continue = module2.createElement(button, {
						LayoutOrder = 1,
						text = props.continueText,
						variant = buttonVariant.Emphasis,
						size = inputSize.Medium,
						width = UDim.new(1, 0),
						isDisabled = not props.isConsentChecked,
						onActivated = props.onConfirm,
						testId = "first-time-purchase-consent-continue"
					}),
					Cancel = module2.createElement(button, {
						LayoutOrder = 2,
						text = props.cancelText,
						variant = buttonVariant.Standard,
						size = inputSize.Medium,
						width = UDim.new(1, 0),
						onActivated = props.onCancel,
						testId = "first-time-purchase-consent-cancel"
					})
				}
			)
		})
	})
end

return FirstTimePurchaseConsentDialogView
