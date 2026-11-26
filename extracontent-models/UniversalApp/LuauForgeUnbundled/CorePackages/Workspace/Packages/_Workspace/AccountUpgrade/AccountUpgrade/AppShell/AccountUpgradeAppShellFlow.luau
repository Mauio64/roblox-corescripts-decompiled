local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow")
local AccountUpgradeContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeContainer")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/useAccountUpgradeViewModel")
local isAccountUpgradeErrorUnrecoverable = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Utils/isAccountUpgradeErrorUnrecoverable")

local function AccountUpgradeAppShellFlow(props)
	local onComplete = props.onComplete
	local v5 = React.useCallback(function(p2)
		if p2.isSuccess then
			onComplete(p2)
		end
	end, { onComplete })

	local onUnrecoverableFailure = props.onUnrecoverableFailure
	local v6 = React.useCallback(function(p2)
		if onUnrecoverableFailure and isAccountUpgradeErrorUnrecoverable(p2) then
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
		onSignUpComplete = v5,
		onSignUpFailed = v6
	})
end

return AccountUpgradeAppShellFlow
