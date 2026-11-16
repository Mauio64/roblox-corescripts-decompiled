local module = require("@luauforge/bundled/hBF")
local module2 = require("@luauforge/bundled/hBE")
local module3 = require("@luauforge/bundled/hBH")
require("@luauforge/bundled/hBC")

require("@luauforge/bundled/hBy")

return function(props)
	local initialActivationWorkflowState = props.initialActivationWorkflowState
	local v5 = {
		namespace = initialActivationWorkflowState.namespace,
		currentState = initialActivationWorkflowState.state,
		payloadTable = initialActivationWorkflowState.payload,
		sessionId = "",
		availableActions = initialActivationWorkflowState.availableActions,
		history = initialActivationWorkflowState.history,
		onClose = props.onClose,
		onWorkflowComplete = props.onWorkflowComplete,
		isLoading = false,
		navigation = {}
	}

	local v6, v7 = module.useReducer(module3, v5)

	return module.createElement(module2.Provider, {
		value = {
			activationFrameworkState = v6,
			dispatch = v7,
			monoDeps = props.monoDeps
		}
	}, props.children)
end
