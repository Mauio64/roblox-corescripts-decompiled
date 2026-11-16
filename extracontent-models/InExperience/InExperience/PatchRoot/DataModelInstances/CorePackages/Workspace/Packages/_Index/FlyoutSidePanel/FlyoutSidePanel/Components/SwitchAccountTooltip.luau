local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useAccountSwitcherTooltip = require(FlyoutSidePanel.Hooks.useAccountSwitcherTooltip)

local EducationalTooltip = Foundation.EducationalTooltip
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function SwitchAccountTooltip(props)
	local v = useLocalization({
		title = "Feature.FlyoutSidePanel.Title.AccountSwitcherMoved",
		text = "Feature.FlyoutSidePanel.Description.SwitchAccountsHere"
	})

	local isOpen, onClose, onPressedOutside = useAccountSwitcherTooltip(
		props.anchorRef,
		props.isEligible,
		props.appStorage,
		props.dismissRef
	)

	return React.createElement(EducationalTooltip, {
		title = v.title,
		text = v.text,
		isOpen = isOpen,
		anchorRef = props.anchorRef,
		align = PopoverAlign.Center,
		side = PopoverSide.Bottom,
		onClose = onClose,
		onPressedOutside = onPressedOutside,
		testId = "--core-ui-flyout-account-switcher-tooltip"
	})
end

return SwitchAccountTooltip
