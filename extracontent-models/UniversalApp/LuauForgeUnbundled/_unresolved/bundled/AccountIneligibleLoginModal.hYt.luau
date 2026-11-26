local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useModalFocus = require("@luauforge/bundled/ghc").useModalFocus

local module = require("@luauforge/bundled/fCM")

local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local orientation = Foundation.Enums.Orientation

local function AccountIneligibleLoginModal(props)
	local v5 = useDispatch()
	local v6 = useModalFocus()
	local v7 = useLocalization({
		title = props.titleKey or "Authentication.Login.Heading.AccountIneligible",
		description = props.descriptionKey or "Authentication.Login.Description.AccountIneligible",
		action = props.actionKey or "CommonUI.Controls.Action.OK"
	})

	local v8 = React.useCallback(function()
		v5(module())
		props.onDismiss()
	end, { v5, props.onDismiss })

	return React.createElement(dialog.Root, {
		size = dialogSize.Small,
		hasBackdrop = true,
		disablePortal = not props.portalToFoundationOverlay,
		ref = v6
	}, {
		Content = React.createElement(dialog.Content, nil, {
			Body = React.createElement(
				Foundation.View,
				{
					tag = "col items-start gap-small size-full-0 auto-y padding-top-large"
				},
				{
					Heading = React.createElement(
						Foundation.View,
						{
							LayoutOrder = 1,
							tag = "row align-y-center gap-large size-full-0 auto-y"
						},
						{
							WarningIcon = React.createElement(Foundation.Image, {
								Image = "icons/status/alert",
								LayoutOrder = 1,
								tag = "size-600 content-system-warning"
							}),
							Title = React.createElement(Foundation.Text, {
								LayoutOrder = 2,
								Text = v7.title,
								tag = "fill auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
							})
						}
					),
					Description = React.createElement(Foundation.Text, {
						LayoutOrder = 2,
						Text = v7.description,
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
					})
				}
			)
		}),
		Actions = React.createElement(dialog.Actions, {
			orientation = orientation.Vertical,
			actions = {
				{ text = v7.action, variant = buttonVariant.Emphasis, onActivated = v8 }
			}
		})
	})
end

return AccountIneligibleLoginModal
