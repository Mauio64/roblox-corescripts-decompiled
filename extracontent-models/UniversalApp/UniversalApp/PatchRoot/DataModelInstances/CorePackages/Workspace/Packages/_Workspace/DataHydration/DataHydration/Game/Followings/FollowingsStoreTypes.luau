local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
require(DataHydrationParent.Signals)

local t = require(DataHydrationParent.t)

return {
	followingResponseValidator = t.interface({
		UniverseId = t.number,
		UserId = t.number,
		CanFollow = t.boolean,
		IsFollowing = t.boolean,
		FollowingCountByType = t.optional(t.number),
		FollowingLimitByType = t.optional(t.number)
	})
}
