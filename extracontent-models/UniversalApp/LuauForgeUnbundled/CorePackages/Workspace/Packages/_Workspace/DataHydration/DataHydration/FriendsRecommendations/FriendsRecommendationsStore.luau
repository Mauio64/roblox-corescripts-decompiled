local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createFriendsRecommendationsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/createFriendsRecommendationsStore")

local computed = Signals.createComputed(createFriendsRecommendationsStore)

return {
	get = function()
		return computed(false)
	end
}
