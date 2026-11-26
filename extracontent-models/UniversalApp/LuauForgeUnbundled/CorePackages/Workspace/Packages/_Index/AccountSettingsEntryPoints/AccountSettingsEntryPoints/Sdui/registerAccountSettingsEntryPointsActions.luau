local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerAccountSettingsEntryPointsActions()
	local v5 = {
		[sduiActionType.OpenAccountSettings] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/Sdui/SduiOpenAccountSettingsAction")
			end,
			skipUnifiedLogging = false
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerAccountSettingsEntryPointsActions
