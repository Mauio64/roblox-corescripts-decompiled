local useCoreActionBind = require(script.Parent.useCoreActionBind)
local SelectionInputs = require(script.Parent.SelectionInputs)

local function useSelectionActivateAction(data)
	useCoreActionBind({
		enabled = data.enabled,
		active = data.active,
		actionNamePrefix = data.actionNamePrefix,
		inputs = SelectionInputs.Activate,
		onAction = data.onAction,
		shouldBind = data.shouldBind,
		rebindSignal = data.rebindSignal,
		contextActionService = data.contextActionService
	})
end

return useSelectionActivateAction
