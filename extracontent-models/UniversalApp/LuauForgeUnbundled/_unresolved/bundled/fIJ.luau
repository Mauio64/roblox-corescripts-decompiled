local fFlagEnableLuaAccountSwitch = require("@luauforge/bundled/fHR").FFlagEnableLuaAccountSwitch

return {
	isAccountPickerEnabled = function(p2): boolean
		return p2.isAccountPickerEnabled == true
	end,
	isAccountSwitcherEnabled = function(p2): boolean
		if fFlagEnableLuaAccountSwitch == true then
			return p2.isAccountSwitcherEnabled == true
		end

		return false
	end
}
