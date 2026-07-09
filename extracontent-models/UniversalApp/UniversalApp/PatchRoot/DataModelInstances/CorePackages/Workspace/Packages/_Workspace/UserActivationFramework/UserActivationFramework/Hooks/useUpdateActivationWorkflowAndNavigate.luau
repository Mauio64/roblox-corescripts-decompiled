local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local React = require(UserActivationFrameworkParent.React)
local FullPageActivationFrameworkContext = require(UserActivationFramework.Context.FullPageActivationFrameworkContext)
local UpdateActivationWorkflow = require(UserActivationFramework.Thunks.UpdateActivationWorkflow)

require(UserActivationFramework.Enums.NavigationAction)

local UserActivationSignupPageState = require(UserActivationFramework.Enums.UserActivationSignupPageState)
local ActivationFrameworkContextAction = require(UserActivationFramework.Enums.ActivationFrameworkContextAction)

require(UserActivationFramework.Enums.Namespace)
require(UserActivationFramework.Enums.PayloadKey)

return function(p1) -- line: 12
	-- upvalues: React (copy), FullPageActivationFrameworkContext (copy), UpdateActivationWorkflow (copy), UserActivationSignupPageState (copy), ActivationFrameworkContextAction (copy)
	local v9 = React.useContext(FullPageActivationFrameworkContext)
	local activationFrameworkState = v9.activationFrameworkState
	local dispatch = v9.dispatch
	local namespace = activationFrameworkState.namespace

	return React.useCallback(function(p2, t1: {[any]: any}?) -- line: 18
		-- upvalues: UpdateActivationWorkflow (copy), namespace (copy), activationFrameworkState (copy), UserActivationSignupPageState (copy), dispatch (copy), ActivationFrameworkContextAction (copy), p1 (copy)
		local v15 = UpdateActivationWorkflow(namespace, activationFrameworkState.currentState, activationFrameworkState.payloadTable, p2, activationFrameworkState.history, t1)

		if v15 == nil then
			activationFrameworkState.onClose()

			return
		end

		if v15.state == UserActivationSignupPageState.Complete then
			activationFrameworkState.onWorkflowComplete(activationFrameworkState.payloadTable)

			return
		end

		dispatch({
			type = ActivationFrameworkContextAction.SetActivationFrameworkState,
			data = {
				currentState = v15.state,
				availableActions = v15.availableActions,
				history = v15.history
			}
		})
		p1.navigate(v15.state)
	end, {
		p1,
		activationFrameworkState.currentState,
		activationFrameworkState.payloadTable,
		dispatch
	})
end
