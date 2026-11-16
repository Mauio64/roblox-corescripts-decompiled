local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization
local useAccountSwitcherTooltip = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useAccountSwitcherTooltip")

local educationalTooltip = Foundation.EducationalTooltip
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local function SwitchAccountTooltip(props)
	local v5 = useLocalization({
		title = "Feature.FlyoutSidePanel.Title.AccountSwitcherMoved",
		text = "Feature.FlyoutSidePanel.Description.SwitchAccountsHere"
	})

	local v6, v7, v8 = useAccountSwitcherTooltip(props.anchorRef, props.isEligible, props.appStorage, props.dismissRef)

	return React.createElement(educationalTooltip, {
		title = v5.title,
		text = v5.text,
		isOpen = v6,
		anchorRef = props.anchorRef,
		align = popoverAlign.Center,
		side = popoverSide.Bottom,
		onClose = v7,
		onPressedOutside = v8,
		testId = "--core-ui-flyout-account-switcher-tooltip"
	})
end

return SwitchAccountTooltip
