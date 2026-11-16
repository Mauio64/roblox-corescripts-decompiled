local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local React = require(ViewRecyclerReact.Parent.React)
local RecyclableViewReadiness = require(ViewRecyclerReact.ReactAdapter.RecyclableViewReadiness)
local SignalsReact = require(ViewRecyclerReact.Parent.SignalsReact)
local createRecyclableView = require(ViewRecyclerReact.ReactAdapter.createRecyclableView)

local function createRecyclableComponent(callback, options)
	local v = type(callback) == "function"

	local function OrdinaryPropsAdapter(p)
		local v2 = SignalsReact.useSignalState(p.itemSignal)
		assert(
			type(v2) == "table",
			"createRecyclableComponent: the item must be a props table; use createRecyclableView for other item values"
		)

		local clone = table.clone(v2)
		clone.pending = p.pending

		if v then
			return callback(clone)
		end

		return React.createElement(callback, clone)
	end

	local clone = table.clone(options or {})

	if clone.readiness == nil then
		clone.readiness = RecyclableViewReadiness.ReadyOnCommit
	end

	return createRecyclableView(OrdinaryPropsAdapter, clone)
end

return createRecyclableComponent
