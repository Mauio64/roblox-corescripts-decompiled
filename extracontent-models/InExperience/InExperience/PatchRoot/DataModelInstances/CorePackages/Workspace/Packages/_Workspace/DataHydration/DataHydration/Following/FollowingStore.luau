local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createFollowingStore = require(script.Parent.createFollowingStore)

local computed = Signals.createComputed(createFollowingStore)

return {
	get = function()
		return computed(false)
	end
}
