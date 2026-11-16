local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
require(parent.Signals)
local t = require(parent.t)

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
