local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Localization")

local AccountUpgradeDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/SuccessModal/AccountUpgradeDialog")
local AccountUpgradeIdentityHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/SuccessModal/AccountUpgradeIdentityHeader")
local AccountUpgradeDialogActions = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/SuccessModal/AccountUpgradeDialogActions")

local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local useLocalization = Localization.Hooks.useLocalization

local function AccountUpgradeSuccessView(props)
	local v5 = useLocalization({
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

	local v6 = props.didUsernameChange and props.canRespawn ~= false

	local v7 = if v6 then v5.usernameChangedBody else v5.usernameUnchangedBody
	local v8

	if v6 then
		v8 = {
			{
				text = v5.respawnNowText,
				variant = buttonVariant.Emphasis,
				onActivated = props.onRespawnNow
			},
			{
				text = v5.applyLaterText,
				variant = buttonVariant.Standard,
				onActivated = props.onApplyLater
			}
		}
	else
		v8 = {
			{
				text = v5.confirmText,
				variant = buttonVariant.Emphasis,
				onActivated = props.onConfirm
			}
		}
	end

	local element = React.createElement(
		view,
		{ tag = "col align-x-center gap-xxlarge size-full-0 auto-y" },
		{
			IdentityHeader = React.createElement(AccountUpgradeIdentityHeader, {
				userId = props.userId,
				displayName = props.displayName,
				username = props.username,
				LayoutOrder = 1
			}),
			BodyAndActions = React.createElement(
				view,
				{
					tag = "col align-x-center gap-xlarge size-full-0 auto-y",
					LayoutOrder = 2
				},
				{
					Body = React.createElement(text, {
						tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
						Text = v7,
						LayoutOrder = 1,
						testId = "account-upgrade-success-body"
					}),
					Actions = React.createElement(AccountUpgradeDialogActions, {
						LayoutOrder = 2,
						buttons = v8
					})
				}
			)
		}
	)

	return React.createElement(AccountUpgradeDialog, {
		hasBackdrop = props.hasBackdrop,
		testId = "account-upgrade-success-dialog",
		children = { Content = element }
	})
end

return AccountUpgradeSuccessView
