local parent = script:FindFirstAncestor("RecommendationsStore").Parent

local Signals = require(parent.Signals)

local createFriendRecommendationsStore = require(script.Parent.createFriendRecommendationsStore)

local computed = Signals.createComputed(createFriendRecommendationsStore)

return function()
	return computed(false)
end
