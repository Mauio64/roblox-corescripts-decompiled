local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")

local linkedText = require("@luauforge/bundled/hxg").LinkedText

local button = Foundation.Button
local checkbox = Foundation.Checkbox
local dialog = Foundation.Dialog
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local function FirstTimePurchaseConsentDialogView(props)
	local v5 = useTokens()

	return React.createElement(dialog.Root, {
		size = dialogSize.Small,
		hasBackdrop = true,
		disablePortal = false,
		ref = props.focusRef,
		testId = "first-time-purchase-consent-dialog"
	}, {
		Title = React.createElement(dialog.Title, { text = props.title }),
		Body = React.createElement(view, {
			LayoutOrder = 2,
			tag = "col gap-large size-full-0 auto-y"
		}, {
			Description = React.createElement(linkedText, {
				LayoutOrder = 1,
				text = props.description,
				onLinkActivated = props.onLearnMoreActivated,
				fontStyle = v5.Typography.BodyMedium,
				textStyle = v5.Color.Content.Default,
				linkTextStyle = v5.Color.Content.Default,
				testId = "first-time-purchase-consent-description"
			}),
			Confirmation = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "row align-y-top gap-medium size-full-0 auto-y"
				},
				{
					Checkbox = React.createElement(checkbox, {
						LayoutOrder = 1,
						isChecked = props.isConsentChecked,
						onActivated = props.onCheckboxActivated,
						label = "",
						size = inputSize.Medium,
						testId = "first-time-purchase-consent-checkbox"
					}),
					Text = React.createElement(view, {
						LayoutOrder = 2,
						tag = "fill auto-y"
					}, {
						Linked = React.createElement(linkedText, {
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
			Buttons = React.createElement(
				view,
				{ LayoutOrder = 3, tag = "col gap-small size-full-0 auto-y" },
				{
					Continue = React.createElement(button, {
						LayoutOrder = 1,
						text = props.continueText,
						variant = buttonVariant.Emphasis,
						size = inputSize.Medium,
						width = UDim.new(1, 0),
						isDisabled = not props.isConsentChecked,
						onActivated = props.onConfirm,
						testId = "first-time-purchase-consent-continue"
					}),
					Cancel = React.createElement(button, {
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
