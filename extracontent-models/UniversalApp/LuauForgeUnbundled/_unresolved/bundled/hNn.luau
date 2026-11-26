local module = require("@luauforge/bundled/hMW")
local module2 = require("@luauforge/bundled/hMV")
local module3 = require("@luauforge/bundled/hNo")
require("@luauforge/bundled/hMO")
local module4 = require("@luauforge/bundled/hMN")
local module5 = require("@luauforge/bundled/hMM")
require("@luauforge/bundled/hMQ")
require("@luauforge/bundled/hMP")

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
