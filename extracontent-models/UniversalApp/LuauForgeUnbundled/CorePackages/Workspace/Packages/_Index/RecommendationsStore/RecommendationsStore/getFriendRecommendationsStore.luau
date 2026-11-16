local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/RecommendationsStore/Signals")

local createFriendRecommendationsStore = require("@game/CorePackages/Workspace/Packages/_Index/RecommendationsStore/RecommendationsStore/createFriendRecommendationsStore")

local computed = Signals.createComputed(createFriendRecommendationsStore)

return function()
	return computed(false)
end
