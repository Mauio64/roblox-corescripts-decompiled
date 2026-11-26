local module = require("@luauforge/bundled/gmo")
local module2 = require("@luauforge/bundled/gmp")

local dialog = module2.Dialog
local dialogSize = module2.Enums.DialogSize
local buttonVariant = module2.Enums.ButtonVariant
local orientation = module2.Enums.Orientation
local useLocalization = require("@luauforge/bundled/gmt").Hooks.useLocalization
local fFlagAccountSwitcherFocusNavigation = require("@luauforge/bundled/gml").FFlagAccountSwitcherFocusNavigation
local useModalFocus = require("@luauforge/bundled/gmy").useModalFocus

local function RemoveAccountDialog(props)
	local v5 = useLocalization({
		removeAccount = "Authentication.AccountPicker.Label.RemoveAccount",
		removeAllAccounts = "Authentication.AccountSwitch.Action.RemoveAllAccounts",
		cancel = "Authentication.AccountPicker.Label.RemoveAccountCancel",
		remove = "Authentication.AccountPicker.Label.RemoveAccountRemove",
		continue = "Authentication.AccountSwitch.Action.Continue",
		removeAccountDescription = "Authentication.AccountPicker.Label.RemoveAccountDescription",
		removeAllAccountsDescription = "Authentication.AccountSwitch.Description.RemoveAllAccounts",
		removeCurrentAccountHeader = "Authentication.AccountSwitch.Header.RemoveCurrentAccount",
		removeCurrentAccountDescription = "Authentication.AccountSwitch.Description.RemoveCurrentAccount"
	})

	local v6 = useModalFocus()
	local v7, v8, v9

	if props.hideAllAccounts then
		v7 = v5.removeAllAccounts
		v8 = v5.removeAllAccountsDescription
		v9 = v5.continue
	else
		if props.isCurrentUser then
			v7 = v5.removeCurrentAccountHeader
			v8 = v5.removeCurrentAccountDescription
		else
			v7 = v5.removeAccount
			v8 = v5.removeAccountDescription
		end

		v9 = v5.remove
	end

	local createElement = module.createElement
	local root = dialog.Root
	local v10 = {
		size = dialogSize.Small,
		hasBackdrop = true,
		closeOnClickOutside = true,
		ref = 0,
		disablePortal = false
	}

	if not fFlagAccountSwitcherFocusNavigation then
		v6 = nil
	end

	v10.ref = v6
	return createElement(root, v10, {
		DialogTitle = module.createElement(dialog.Title, { text = v7 }),
		DialogContent = module.createElement(dialog.Content, nil, {
			DialogView = module.createElement(
				module2.View,
				{ tag = "col fill auto-xy items-start gap-medium" },
				{
					DialogText = module.createElement(dialog.Text, {
						Text = v8,
						LayoutOrder = 1
					})
				}
			)
		}),
		DialogActions = module.createElement(dialog.Actions, {
			orientation = orientation.Vertical,
			actions = {
				{
					text = v9,
					variant = buttonVariant.Alert,
					onActivated = props.onRemove
				},
				{
					text = v5.cancel,
					variant = buttonVariant.Standard,
					onActivated = props.onClose
				}
			}
		})
	})
end

return RemoveAccountDialog
