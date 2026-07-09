local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local React = require(UserActivationFrameworkParent.React)
local FullPageActivationFrameworkContext = require(UserActivationFramework.Context.FullPageActivationFrameworkContext)
local ActivationFrameworkReducer = require(UserActivationFramework.Reducers.ActivationFrameworkReducer)

require(UserActivationFramework.Types.ActivationFrameworkContextTypes)
require(UserActivationFramework.Enums.PayloadKey)

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), ActivationFrameworkReducer (copy), FullPageActivationFrameworkContext (copy)
	local initialActivationWorkflowState = t1.initialActivationWorkflowState
	local t2 = {
		sessionId = "",
		isLoading = false,
		namespace = initialActivationWorkflowState.namespace,
		currentState = initialActivationWorkflowState.state,
		payloadTable = initialActivationWorkflowState.payload,
		availableActions = initialActivationWorkflowState.availableActions,
		history = initialActivationWorkflowState.history,
		onClose = t1.onClose,
		onWorkflowComplete = t1.onWorkflowComplete,
		navigation = {}
	}
	local v9, v10 = React.useReducer(ActivationFrameworkReducer, t2)

	return React.createElement(FullPageActivationFrameworkContext.Provider, {
		value = {
			activationFrameworkState = v9,
			dispatch = v10,
			monoDeps = t1.monoDeps
		}
	}, t1.children)
end
