local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiComponentType = SduiCoreSystem.SduiComponentType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/SharedFlags")

local fFlagSduiApiStoreUpdateInputData = SharedFlags.FFlagSduiCustomFormEnabled
	and SharedFlags.FFlagSduiUnwrapStructPropEnvelope
	and SharedFlags.FFlagSduiApiStoreUpdateInputData

local function registerCustomFormActions()
	local v5 = {
		[sduiActionType.SubmitCustomFormResponse] = fFlagSduiApiStoreUpdateInputData and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/SduiSubmitCustomFormResponseAction")
			end,
			skipUnifiedLogging = false
		} or nil,
		[sduiActionType.RefreshCustomFormResults] = fFlagSduiApiStoreUpdateInputData and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/SduiRefreshCustomFormResultsAction")
			end,
			skipUnifiedLogging = true
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

local function registerCustomFormComponents()
	local v5 = {
		[sduiComponentType.CustomForm] = fFlagSduiApiStoreUpdateInputData and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/SduiCustomForm")
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v5)
end

return {
	registerCustomForms = function()
		registerCustomFormActions()
		registerCustomFormComponents()
	end,
	registerCustomFormActions = registerCustomFormActions,
	registerCustomFormComponents = registerCustomFormComponents
}
