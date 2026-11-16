local Immutable = require(script.Parent.Parent.Immutable)

local Actions = script.Parent.Parent.Actions
local SetLuauHeapState = require(Actions.SetLuauHeapState)
local SetLuauHeapProfileTarget = require(Actions.SetLuauHeapProfileTarget)
local SetLuauHeapActiveSnapshot = require(Actions.SetLuauHeapActiveSnapshot)
local SetLuauHeapCompareSnapshot = require(Actions.SetLuauHeapCompareSnapshot)
require(script.Parent.Parent.Components.LuauHeap.LuauHeapTypes)

local v = {
	isClientView = true,
	client = { snapshots = {}, active = 0, compare = 0 },
	server = { snapshots = {}, active = 0, compare = 0 }
}

return function(p, data)
	local selected = p or v

	if data.type == SetLuauHeapState.name then
		local v2

		if data.isClientState then
			v2 = { client = data.sessionState }
		else
			v2 = { server = data.sessionState }
		end

		return (Immutable.JoinDictionaries(selected, v2))
	end

	if data.type == SetLuauHeapProfileTarget.name then
		return Immutable.JoinDictionaries(selected, { isClientView = data.isClientView })
	end

	if data.type == SetLuauHeapActiveSnapshot.name then
		if selected.isClientView then
			local clone = table.clone(selected.client)
			clone.active = data.active
			return Immutable.JoinDictionaries(selected, { client = clone })
		else
			local clone = table.clone(selected.server)
			clone.active = data.active
			return Immutable.JoinDictionaries(selected, { server = clone })
		end
	else
		if data.type ~= SetLuauHeapCompareSnapshot.name then
			return selected
		end

		if selected.isClientView then
			local clone = table.clone(selected.client)
			clone.compare = data.compare
			return Immutable.JoinDictionaries(selected, { client = clone })
		else
			local clone = table.clone(selected.server)
			clone.compare = data.compare
			return Immutable.JoinDictionaries(selected, { server = clone })
		end
	end
end
