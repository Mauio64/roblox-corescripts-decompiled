local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local RoactUtils = require(parent.RoactUtils)
local useIOSStatusBarStyler = RoactUtils.Hooks.useIOSStatusBarStyler

require(AccountUpgrade.AccountUpgradeFlow)
local AccountUpgradeSurface = require(AccountUpgrade.AccountUpgradeSurface)
require(AccountUpgrade.AppShell.AccountUpgradeAppShellFlow)
local useAccountUpgradeViewModel = require(AccountUpgrade.Components.useAccountUpgradeViewModel)
local isAccountUpgradeErrorUnrecoverable = require(AccountUpgrade.Utils.isAccountUpgradeErrorUnrecoverable)
local AccountUpgradePageView = require(script.Parent.AccountUpgradePageView)

local View = Foundation.View

local style = {
	themeName = Foundation.Enums.ColorMode.Dark,
	fontName = Style.Constants.FontName.Gotham
}

local function AccountUpgradePage(props)
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

	local v = useAccountUpgradeViewModel({
		flow = props.flow,
		surface = AccountUpgradeSurface.FullPage,
		currentUsername = props.currentUsername,
		onSignUpComplete = onSignUpComplete,
		onSignUpFailed = onSignUpFailed,
		onSignOut = props.onSignOut,
		onLegalLinkSelected = props.onLegalLinkSelected
	})

	useIOSStatusBarStyler(true)

	return React.createElement(View, { tag = "size-full", testId = "AccountUpgradePageTheme" }, {
		Theme = React.createElement(Style.UiModeStyleProvider, { style = style }, {
			Page = React.createElement(AccountUpgradePageView, v)
		})
	})
end

return AccountUpgradePage
