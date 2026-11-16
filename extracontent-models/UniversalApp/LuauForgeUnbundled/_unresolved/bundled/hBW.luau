local module = require("@luauforge/bundled/hBF")
local module2 = require("@luauforge/bundled/hBE")
local module3 = require("@luauforge/bundled/hBX")
require("@luauforge/bundled/hBx")
local module4 = require("@luauforge/bundled/hBw")
local module5 = require("@luauforge/bundled/hBv")
require("@luauforge/bundled/hBz")
require("@luauforge/bundled/hBy")

return function(p2)
	local v5 = module.useContext(module2)
	local activationFrameworkState = v5.activationFrameworkState
	local dispatch = v5.dispatch
	local namespace = activationFrameworkState.namespace
	return module.useCallback(function(p3, p4)
		local v6 = module3(
			namespace,
			activationFrameworkState.currentState,
			activationFrameworkState.payloadTable,
			p3,
			activationFrameworkState.history,
			p4
		)

		if v6 == nil then
			activationFrameworkState.onClose()
			return
		end

		if v6.state == module4.Complete then
			activationFrameworkState.onWorkflowComplete(activationFrameworkState.payloadTable)
			return
		end

		dispatch({
			type = module5.SetActivationFrameworkState,
			data = {
				currentState = v6.state,
				availableActions = v6.availableActions,
				history = v6.history
			}
		})

		p2.navigate(v6.state)
	end, {
		p2,
		activationFrameworkState.currentState,
		activationFrameworkState.payloadTable,
		dispatch
	})
end
