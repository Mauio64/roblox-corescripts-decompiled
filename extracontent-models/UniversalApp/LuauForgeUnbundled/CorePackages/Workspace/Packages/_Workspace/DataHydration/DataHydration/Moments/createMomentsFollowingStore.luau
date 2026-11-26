local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local fetchFollowingMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/fetchFollowingMoments")

local function createMomentsFollowingStore(options)
	local v5 = options or {}

	return {
		getFollowing = function(p2)
			return HttpClient.asPromise(fetchFollowingMoments(p2, v5.network))
		end,
		clear = function() end,
		dispose = function() end
	}
end

return createMomentsFollowingStore
