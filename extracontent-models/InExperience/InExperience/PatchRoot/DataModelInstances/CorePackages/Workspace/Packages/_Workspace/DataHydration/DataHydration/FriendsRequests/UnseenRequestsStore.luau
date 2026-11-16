local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createUnseenRequestsStore = require(script.Parent.createUnseenRequestsStore)

local computed = Signals.createComputed(createUnseenRequestsStore)

return {
	get = function()
		return computed(false)
	end
}
