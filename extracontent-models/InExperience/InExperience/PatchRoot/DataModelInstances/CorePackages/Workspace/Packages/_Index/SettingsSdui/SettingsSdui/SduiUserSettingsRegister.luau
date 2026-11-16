local SettingsSdui = script:FindFirstAncestor("SettingsSdui")
local parent = SettingsSdui.Parent
local React = require(parent.React)

local registerUserSettingsActions = require(SettingsSdui.registerUserSettingsActions)

local function SduiUserSettingsRegister(): nil
	React.useEffect(function()
		registerUserSettingsActions()
	end, {})
	return nil
end

return React.memo(SduiUserSettingsRegister)
