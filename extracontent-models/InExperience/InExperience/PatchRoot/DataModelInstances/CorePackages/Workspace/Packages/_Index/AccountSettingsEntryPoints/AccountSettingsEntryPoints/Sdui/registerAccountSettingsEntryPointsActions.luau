local AccountSettingsEntryPoints = script:FindFirstAncestor("AccountSettingsEntryPoints")
local parent = AccountSettingsEntryPoints.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerAccountSettingsEntryPointsActions()
	local v = {
		[SduiActionType.OpenAccountSettings] = {
			lazyHandler = function()
				return require(AccountSettingsEntryPoints.Sdui.SduiOpenAccountSettingsAction)
			end,
			skipUnifiedLogging = false
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v)
end

return registerAccountSettingsEntryPointsActions
