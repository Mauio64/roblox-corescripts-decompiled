local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)

require(AccountUpgrade.AccountUpgradeFlow)
local AccountUpgradeContainer = require(AccountUpgrade.Components.AccountUpgradeContainer)
require(AccountUpgrade.Components.useAccountUpgradeViewModel)
local isAccountUpgradeErrorUnrecoverable = require(AccountUpgrade.Utils.isAccountUpgradeErrorUnrecoverable)

local function AccountUpgradeAppShellFlow(props)
	local onComplete = props.onComplete
	local onSignUpComplete = React.useCallback(function(p)
		if p.isSuccess then
			onComplete(p)
		end
	end, { onComplete })

	local onUnrecoverableFailure = props.onUnrecoverableFailure
	local onSignUpFailed = React.useCallback(function(p: number?)
		if onUnrecoverableFailure and isAccountUpgradeErrorUnrecoverable(p) then
			onUnrecoverableFailure()
		end
	end, { onUnrecoverableFailure })

	return React.createElement(AccountUpgradeContainer, {
		flow = props.flow,
		currentUsername = props.currentUsername,
		hasBackdrop = props.hasBackdrop,
		onClose = props.onDismiss,
		onSignOut = props.onSignOut,
		onLegalLinkSelected = props.onLegalLinkSelected,
		onSignUpComplete = onSignUpComplete,
		onSignUpFailed = onSignUpFailed
	})
end

return AccountUpgradeAppShellFlow
