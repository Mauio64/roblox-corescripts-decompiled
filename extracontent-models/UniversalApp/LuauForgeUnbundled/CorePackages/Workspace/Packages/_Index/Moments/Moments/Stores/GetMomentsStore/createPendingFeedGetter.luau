local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")

local function createPendingFeedGetter(p2, p3)
	return Signals.createComputed(function(p4)
		return p3.getPendingUserMoments(p4)[p2] or {}
	end)
end

return createPendingFeedGetter
