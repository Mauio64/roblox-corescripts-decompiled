local SettingsSdui = script:FindFirstAncestor("SettingsSdui")
local parent = SettingsSdui.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerUserSettingsActions()
	local v = {
		[SduiActionType.UpdateUserSettings] = {
			lazyHandler = function()
				return require(SettingsSdui.SduiUpdateUserSettingsAction)
			end,
			skipUnifiedLogging = false
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v)
end

return registerUserSettingsActions
