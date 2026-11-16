local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize

local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutAccountSwitcherIXP = SharedExperimentDefinition.FlyoutAccountSwitcherIXP

local SharedFlags = require(parent.SharedFlags)
local FFlagCTAChangeMorePageFlyoutButtonText = SharedFlags.FFlagCTAChangeMorePageFlyoutButtonText

local function FlyoutSwitchAccountButton(props)
	local useCallback = React.useCallback
	local function fn()
		if not FlyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then
			props.closeDrawer()
		end

		if props.onSwitchAccountActivated then
			props.onSwitchAccountActivated()
		end
	end

	local onSwitchAccountActivated = props.onSwitchAccountActivated
	local v

	if not FlyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled() then
		v = props.closeDrawer
	end

	local onActivated = useCallback(fn, { onSwitchAccountActivated, v })

	local v2 = useLocalization({
		title = FFlagCTAChangeMorePageFlyoutButtonText and "Authentication.AccountSwitch.Header.SwitchAccountSentenceCase" or "Authentication.AccountSwitch.Action.SwitchAccount"
	})

	return React.createElement(Button, {
		testId = "--core-ui-flyout-button-switch-account",
		text = v2.title,
		variant = ButtonVariant.Standard,
		LayoutOrder = props.layoutOrder,
		onActivated = onActivated,
		isDisabled = false,
		size = ButtonSize.Large,
		width = UDim.new(1, 0)
	})
end

return FlyoutSwitchAccountButton
