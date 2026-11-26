local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createSduiFriendRecommendationsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/createSduiFriendRecommendationsStore")

local fFlagPymkCarouselExtendProps = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagPymkCarouselExtendProps

local computed = Signals.createComputed(createSduiFriendRecommendationsStore)

if fFlagPymkCarouselExtendProps then
	return nil
end

return function()
	return computed(false)
end
