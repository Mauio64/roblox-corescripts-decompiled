local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerUserSettingsActions()
	local v5 = {
		[sduiActionType.UpdateUserSettings] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SettingsSdui/SettingsSdui/SduiUpdateUserSettingsAction")
			end,
			skipUnifiedLogging = false
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerUserSettingsActions
