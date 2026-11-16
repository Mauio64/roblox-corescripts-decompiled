local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createFriendsStore = require(script.Parent.createFriendsStore)

local computed = Signals.createComputed(createFriendsStore)

return {
	get = function()
		return computed(false)
	end
}
