local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/React")

local registerUserSettingsActions = require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/registerUserSettingsActions")

local function SduiUserSettingsRegister(): nil
	React.useEffect(function()
		registerUserSettingsActions()
	end, {})
	return nil
end

return React.memo(SduiUserSettingsRegister)
