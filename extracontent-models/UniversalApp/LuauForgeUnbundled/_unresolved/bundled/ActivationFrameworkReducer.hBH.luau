local module = require("@luauforge/bundled/hBI")
local module2 = require("@luauforge/bundled/hBv")
require("@luauforge/bundled/hBB")

local function ActivationFrameworkReducer(p2, p3)
	local clone = table.clone(p2)

	if p3.type == module2.SetActivationFrameworkState then
		return (module.Dictionary.join(clone, p3.data))
	end

	if p3.type == module2.SetSessionId then
		clone.sessionId = p3.data.sessionId
		return clone
	end

	if p3.type == module2.SetAvailableActions then
		clone.availableActions = p3.data.availableActions
		return clone
	end

	if p3.type == module2.SetOnClose then
		clone.onClose = p3.data.onClose
		return clone
	end

	if p3.type == module2.SetIsLoading then
		clone.isLoading = p3.data.isLoading
		return clone
	end

	if p3.type == module2.SetMergePayload then
		clone.payloadTable = module.Dictionary.join(clone.payloadTable, p3.data.payloadTable)
		return clone
	end

	if p3.type == module2.ClearPayload then
		clone.payloadTable = {}
	end

	return clone
end

return ActivationFrameworkReducer
