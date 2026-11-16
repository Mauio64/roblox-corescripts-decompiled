require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

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
