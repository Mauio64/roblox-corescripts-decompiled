local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createFriendsRequestsStore = require(script.Parent.createFriendsRequestsStore)

local computed = Signals.createComputed(createFriendsRequestsStore)

return {
	get = function()
		return computed(false)
	end
}
