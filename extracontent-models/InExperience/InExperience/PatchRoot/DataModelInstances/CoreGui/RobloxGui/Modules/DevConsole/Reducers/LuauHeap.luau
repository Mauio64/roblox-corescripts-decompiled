local Immutable = require(script.Parent.Parent.Immutable)
local Actions = script.Parent.Parent.Actions
local SetLuauHeapState = require(Actions.SetLuauHeapState)
local SetLuauHeapProfileTarget = require(Actions.SetLuauHeapProfileTarget)
local SetLuauHeapActiveSnapshot = require(Actions.SetLuauHeapActiveSnapshot)
local SetLuauHeapCompareSnapshot = require(Actions.SetLuauHeapCompareSnapshot)

require(script.Parent.Parent.Components.LuauHeap.LuauHeapTypes)

local t1 = {
	isClientView = true,
	client = {
		active = 0,
		compare = 0,
		snapshots = {}
	},
	server = {
		active = 0,
		compare = 0,
		snapshots = {}
	}
}

return function(t2: {[any]: any}?, t3: {[any]: any}) -- line: 33
	-- upvalues: t1 (copy), SetLuauHeapState (copy), Immutable (copy), SetLuauHeapProfileTarget (copy), SetLuauHeapActiveSnapshot (copy), SetLuauHeapCompareSnapshot (copy)
	local v10 = t2 or t1

	if t3.type == SetLuauHeapState.name then
		local v11 = if not t3.isClientState then {
			server = t3.sessionState
		} else {
			client = t3.sessionState
		}

		return (Immutable.JoinDictionaries(v10, v11))
	end

	if t3.type == SetLuauHeapProfileTarget.name then
		return Immutable.JoinDictionaries(v10, {
			isClientView = t3.isClientView
		})
	end

	if t3.type == SetLuauHeapActiveSnapshot.name then
		if v10.isClientView then
			local v12 = table.clone(v10.client)

			v12.active = t3.active

			return Immutable.JoinDictionaries(v10, {
				client = v12
			})
		end

		local v13 = table.clone(v10.server)

		v13.active = t3.active

		return Immutable.JoinDictionaries(v10, {
			server = v13
		})
	end

	if t3.type == SetLuauHeapCompareSnapshot.name then
		if v10.isClientView then
			local v14 = table.clone(v10.client)

			v14.compare = t3.compare

			return Immutable.JoinDictionaries(v10, {
				client = v14
			})
		end

		local v15 = table.clone(v10.server)

		v15.compare = t3.compare

		return Immutable.JoinDictionaries(v10, {
			server = v15
		})
	end

	return v10
end
