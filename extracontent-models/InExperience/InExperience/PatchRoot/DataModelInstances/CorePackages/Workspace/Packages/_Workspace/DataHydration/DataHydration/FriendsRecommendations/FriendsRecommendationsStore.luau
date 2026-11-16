local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createFriendsRecommendationsStore = require(script.Parent.createFriendsRecommendationsStore)

local computed = Signals.createComputed(createFriendsRecommendationsStore)

return {
	get = function()
		return computed(false)
	end
}
