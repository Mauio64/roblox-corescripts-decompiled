local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize

local flyoutAccountSwitcherIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedExperimentDefinition").FlyoutAccountSwitcherIXP

local fFlagCTAChangeMorePageFlyoutButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagCTAChangeMorePageFlyoutButtonText

local function FlyoutSwitchAccountButton(props)
	local useCallback = React.useCallback
	local function fn()
		if not flyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then
			props.closeDrawer()
		end

		if props.onSwitchAccountActivated then
			props.onSwitchAccountActivated()
		end
	end

	local onSwitchAccountActivated = props.onSwitchAccountActivated
	local v6 = if not flyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then props.closeDrawer else nil
	local v7 = useCallback(fn, { onSwitchAccountActivated, v6 })

	local v8 = useLocalization({
		title = fFlagCTAChangeMorePageFlyoutButtonText and "Authentication.AccountSwitch.Header.SwitchAccountSentenceCase" or "Authentication.AccountSwitch.Action.SwitchAccount"
	})

	return React.createElement(button, {
		testId = "--core-ui-flyout-button-switch-account",
		text = v8.title,
		variant = buttonVariant.Standard,
		LayoutOrder = props.layoutOrder,
		onActivated = v7,
		isDisabled = false,
		size = buttonSize.Large,
		width = UDim.new(1, 0)
	})
end

return FlyoutSwitchAccountButton
