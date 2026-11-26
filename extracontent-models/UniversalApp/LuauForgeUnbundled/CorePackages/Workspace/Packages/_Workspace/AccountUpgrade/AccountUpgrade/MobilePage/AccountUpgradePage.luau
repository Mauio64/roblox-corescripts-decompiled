local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Style")
local useIOSStatusBarStyler = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/RoactUtils").Hooks.useIOSStatusBarStyler

require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow")
local AccountUpgradeSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeSurface")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AppShell/AccountUpgradeAppShellFlow")
local useAccountUpgradeViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/useAccountUpgradeViewModel")
local isAccountUpgradeErrorUnrecoverable = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Utils/isAccountUpgradeErrorUnrecoverable")
local AccountUpgradePageView = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/AccountUpgradePageView")

local view = Foundation.View

local v5 = {
	themeName = Foundation.Enums.ColorMode.Dark,
	fontName = Style.Constants.FontName.Gotham
}

local function AccountUpgradePage(props)
	local onComplete = props.onComplete
	local v6 = React.useCallback(function(p2)
		if p2.isSuccess then
			onComplete(p2)
		end
	end, { onComplete })

	local onUnrecoverableFailure = props.onUnrecoverableFailure
	local v7 = React.useCallback(function(p2)
		if onUnrecoverableFailure and isAccountUpgradeErrorUnrecoverable(p2) then
			onUnrecoverableFailure()
		end
	end, { onUnrecoverableFailure })

	local v8 = useAccountUpgradeViewModel({
		flow = props.flow,
		surface = AccountUpgradeSurface.FullPage,
		currentUsername = props.currentUsername,
		onSignUpComplete = v6,
		onSignUpFailed = v7,
		onSignOut = props.onSignOut,
		onLegalLinkSelected = props.onLegalLinkSelected
	})

	useIOSStatusBarStyler(true)

	return React.createElement(view, {
		tag = "size-full",
		testId = "AccountUpgradePageTheme"
	}, {
		Theme = React.createElement(Style.UiModeStyleProvider, { style = v5 }, {
			Page = React.createElement(AccountUpgradePageView, v8)
		})
	})
end

return AccountUpgradePage
