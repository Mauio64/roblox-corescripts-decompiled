local defineFastFlag = game:DefineFastFlag("EnableFlyoutUsernameAccountSwitcher", false)
local defineFastFlag2 = game:DefineFastFlag("FlyoutEnableSwitchAccountTooltip", false)
local defineFastInt = game:DefineFastInt("FlyoutUsernameAccountSwitcherVariant", 0)

return {
	isUsernameAccountSwitcherEnabled = function()
		return defineFastFlag
	end,
	isSwitchAccountTooltipEnabled = function()
		return defineFastFlag and defineFastFlag2
	end,
	isProfileHandleEnabled = function()
		return defineFastFlag and defineFastInt == 1
	end,
	isProfileIconButtonEnabled = function()
		return defineFastFlag and defineFastInt == 2
	end,
	isBottomButtonEnabled = function()
		local v5 = not defineFastFlag or defineFastInt ~= 1

		if v5 then
			v5 = not defineFastFlag or defineFastInt ~= 2
		end

		return v5
	end,
	getClickSource = function(): string
		if defineFastFlag and defineFastInt == 1 then
			return "handle"
		end

		if defineFastFlag and defineFastInt == 2 then
			return "icon_button"
		end

		return "bottom_button"
	end
}
