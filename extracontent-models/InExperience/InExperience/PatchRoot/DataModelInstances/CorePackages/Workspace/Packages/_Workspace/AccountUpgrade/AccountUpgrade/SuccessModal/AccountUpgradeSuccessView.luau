local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local AccountUpgradeDialog = require(script.Parent.AccountUpgradeDialog)
local AccountUpgradeIdentityHeader = require(script.Parent.AccountUpgradeIdentityHeader)
local AccountUpgradeDialogActions = require(script.Parent.AccountUpgradeDialogActions)

local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local useLocalization = Localization.Hooks.useLocalization

local function AccountUpgradeSuccessView(props)
	local v = useLocalization({
		usernameChangedBody = {
			"Authentication.SignUp.Description.UsernameChanged",
			platform = props.linkedAccountType
		},
		usernameUnchangedBody = {
			"Authentication.SignUp.Description.UsernameUnchanged",
			platform = props.linkedAccountType
		},
		respawnNowText = "Authentication.SignUp.Action.RespawnNow",
		applyLaterText = "Authentication.SignUp.Action.ApplyOnNextRespawn",
		confirmText = "CommonUI.Controls.Action.OK"
	})

	local v2 = props.didUsernameChange and props.canRespawn ~= false
	local text

	if v2 then
		text = v.usernameChangedBody
	else
		text = v.usernameUnchangedBody
	end

	local buttons

	if v2 then
		buttons = {
			{
				text = v.respawnNowText,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onRespawnNow
			},
			{
				text = v.applyLaterText,
				variant = ButtonVariant.Standard,
				onActivated = props.onApplyLater
			}
		}
	else
		buttons = {
			{
				text = v.confirmText,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onConfirm
			}
		}
	end

	local element = React.createElement(View, {
		tag = "col align-x-center gap-xxlarge size-full-0 auto-y"
	}, {
		IdentityHeader = React.createElement(AccountUpgradeIdentityHeader, {
			userId = props.userId,
			displayName = props.displayName,
			username = props.username,
			LayoutOrder = 1
		}),
		BodyAndActions = React.createElement(
			View,
			{ tag = "col align-x-center gap-xlarge size-full-0 auto-y", LayoutOrder = 2 },
			{
				Body = React.createElement(Text, {
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
					Text = text,
					LayoutOrder = 1,
					testId = "account-upgrade-success-body"
				}),
				Actions = React.createElement(AccountUpgradeDialogActions, {
					LayoutOrder = 2,
					buttons = buttons
				})
			}
		)
	})

	return React.createElement(AccountUpgradeDialog, {
		hasBackdrop = props.hasBackdrop,
		testId = "account-upgrade-success-dialog",
		children = { Content = element }
	})
end

return AccountUpgradeSuccessView
