local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local Cryo = require(UserActivationFrameworkParent.Cryo)
local ActivationFrameworkContextAction = require(UserActivationFramework.Enums.ActivationFrameworkContextAction)

require(UserActivationFramework.Types)

local function ActivationFrameworkReducer(p1, p2) -- line: 7
	-- upvalues: ActivationFrameworkContextAction (copy), Cryo (copy)
	local v8 = table.clone(p1)

	if p2.type == ActivationFrameworkContextAction.SetActivationFrameworkState then
		return (Cryo.Dictionary.join(v8, p2.data))
	end

	if p2.type == ActivationFrameworkContextAction.SetSessionId then
		v8.sessionId = p2.data.sessionId

		return v8
	end

	if p2.type == ActivationFrameworkContextAction.SetAvailableActions then
		v8.availableActions = p2.data.availableActions

		return v8
	end

	if p2.type == ActivationFrameworkContextAction.SetOnClose then
		v8.onClose = p2.data.onClose

		return v8
	end

	if p2.type == ActivationFrameworkContextAction.SetIsLoading then
		v8.isLoading = p2.data.isLoading

		return v8
	end

	if p2.type == ActivationFrameworkContextAction.SetMergePayload then
		v8.payloadTable = Cryo.Dictionary.join(v8.payloadTable, p2.data.payloadTable)

		return v8
	end

	if p2.type == ActivationFrameworkContextAction.ClearPayload then
		v8.payloadTable = {}
	end

	return v8
end

return ActivationFrameworkReducer
