local Parent = script:FindFirstAncestor("LandingPage").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local EnumsOrientation = Foundation.Enums.Orientation
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local GetFFlagEnableManageAccountsRedesign = require(Parent.SharedFlags).GetFFlagEnableManageAccountsRedesign
local GetFFlagEnableAccountSwitcherSignedOutAccounts = require(Parent.SharedFlags).GetFFlagEnableAccountSwitcherSignedOutAccounts

local function RemoveAccountDialog(t1: {[any]: any}) -- line: 23
	-- upvalues: useLocalization (copy), GetFFlagEnableAccountSwitcherSignedOutAccounts (copy), GetFFlagEnableManageAccountsRedesign (copy), React (copy), Dialog (copy), DialogSize (copy), Foundation (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v13 = useLocalization({
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

	if not GetFFlagEnableAccountSwitcherSignedOutAccounts() then
		t1.hideAllAccounts = false
	end

	local removeAllAccounts, removeAllAccountsDescription, continue

	if t1.hideAllAccounts and GetFFlagEnableManageAccountsRedesign() then
		removeAllAccounts = v13.removeAllAccounts
		removeAllAccountsDescription = v13.removeAllAccountsDescription
		continue = v13.continue
	elseif t1.isCurrentUser and GetFFlagEnableManageAccountsRedesign() then
		removeAllAccounts = v13.removeCurrentAccountHeader
		removeAllAccountsDescription = v13.removeCurrentAccountDescription
		continue = v13.remove
	else
		removeAllAccounts = v13.removeAccount
		removeAllAccountsDescription = v13.removeAccountDescription
		continue = v13.remove
	end

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		closeOnClickOutside = true,
		size = DialogSize.Small,
		disablePortal = not GetFFlagEnableManageAccountsRedesign(),
		onClose = not GetFFlagEnableManageAccountsRedesign() and function(_) -- line: 60
			-- upvalues: t1 (copy)
			t1.onClose()
		end or nil
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = removeAllAccounts
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogView = React.createElement(Foundation.View, {
				tag = "col fill auto-xy items-start gap-medium"
			}, {
				DialogText = React.createElement(Dialog.Text, {
					LayoutOrder = 1,
					Text = removeAllAccountsDescription
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			orientation = EnumsOrientation.Vertical,
			actions = {
				{
					text = continue,
					variant = ButtonVariant.Alert,
					onActivated = t1.onRemove
				},
				{
					text = v13.cancel,
					variant = ButtonVariant.Standard,
					onActivated = t1.onClose
				}
			}
		})
	})
end

return RemoveAccountDialog
