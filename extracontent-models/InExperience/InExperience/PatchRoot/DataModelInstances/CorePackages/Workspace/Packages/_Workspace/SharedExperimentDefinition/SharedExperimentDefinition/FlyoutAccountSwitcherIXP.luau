local defineFastFlag = game:DefineFastFlag("EnableFlyoutUsernameAccountSwitcher", false)
local defineFastFlag2 = game:DefineFastFlag("FlyoutEnableSwitchAccountTooltip", false)
local defineFastInt = game:DefineFastInt("FlyoutUsernameAccountSwitcherVariant", 0)

local function isProfileIconButtonEnabled() -- 2 equivalent calls inferred from this helper
	return defineFastFlag and defineFastInt == 2
end

local FlyoutAccountSwitcherIXP = {}

function FlyoutAccountSwitcherIXP.isUsernameAccountSwitcherEnabled()
	return defineFastFlag
end

function FlyoutAccountSwitcherIXP.isSwitchAccountTooltipEnabled()
	return defineFastFlag and defineFastFlag2
end

function FlyoutAccountSwitcherIXP.isProfileHandleEnabled()
	return defineFastFlag and defineFastInt == 1
end

FlyoutAccountSwitcherIXP.isProfileIconButtonEnabled = isProfileIconButtonEnabled

function FlyoutAccountSwitcherIXP.isBottomButtonEnabled(): boolean
	return (not defineFastFlag or defineFastInt ~= 1) and not isProfileIconButtonEnabled() -- inferred equivalent call
end

function FlyoutAccountSwitcherIXP.getClickSource(): string
	if defineFastFlag and defineFastInt == 1 then
		return "handle"
	end

	if isProfileIconButtonEnabled() then -- inferred equivalent call
		return "icon_button"
	end

	return "bottom_button"
end

return FlyoutAccountSwitcherIXP
