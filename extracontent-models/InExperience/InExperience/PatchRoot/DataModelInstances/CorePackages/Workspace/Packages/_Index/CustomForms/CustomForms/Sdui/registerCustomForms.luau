local CustomForms = script:FindFirstAncestor("CustomForms")
local parent = CustomForms.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiComponentType = SduiCoreSystem.SduiComponentType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local SharedFlags = require(parent.SharedFlags)

local fFlagSduiApiStoreUpdateInputData = SharedFlags.FFlagSduiCustomFormEnabled
	and SharedFlags.FFlagSduiUnwrapStructPropEnvelope
	and SharedFlags.FFlagSduiApiStoreUpdateInputData

local function registerCustomFormActions()
	local v = {
		[SduiActionType.SubmitCustomFormResponse] = fFlagSduiApiStoreUpdateInputData and {
			lazyHandler = function()
				return require(CustomForms.Sdui.SduiSubmitCustomFormResponseAction)
			end,
			skipUnifiedLogging = false
		} or nil,
		[SduiActionType.RefreshCustomFormResults] = fFlagSduiApiStoreUpdateInputData and {
			lazyHandler = function()
				return require(CustomForms.Sdui.SduiRefreshCustomFormResultsAction)
			end,
			skipUnifiedLogging = true
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v)
end

local function registerCustomFormComponents()
	local v = {
		[SduiComponentType.CustomForm] = fFlagSduiApiStoreUpdateInputData and {
			getLazyComponent = function()
				return require(CustomForms.Sdui.SduiCustomForm)
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v)
end

return {
	registerCustomForms = function()
		registerCustomFormActions()
		registerCustomFormComponents()
	end,
	registerCustomFormActions = registerCustomFormActions,
	registerCustomFormComponents = registerCustomFormComponents
}
