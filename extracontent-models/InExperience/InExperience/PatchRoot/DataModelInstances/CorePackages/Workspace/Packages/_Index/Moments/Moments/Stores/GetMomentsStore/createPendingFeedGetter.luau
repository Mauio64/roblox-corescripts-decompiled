local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Signals = require(parent.Signals)
require(parent.DataHydration.MomentsStoreTypes)
require(Moments.Components.Feed.FeedTypes)

local function createPendingFeedGetter(p: number, p2)
	return Signals.createComputed(function(p3)
		return p2.getPendingUserMoments(p3)[p] or {}
	end)
end

return createPendingFeedGetter
