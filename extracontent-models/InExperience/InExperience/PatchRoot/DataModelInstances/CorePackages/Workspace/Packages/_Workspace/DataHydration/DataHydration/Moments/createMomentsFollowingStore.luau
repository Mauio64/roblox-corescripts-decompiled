local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
require(script.Parent.MomentsStoreTypes)
local fetchFollowingMoments = require(script.Parent.Requests.fetchFollowingMoments)

local function createMomentsFollowingStore(options)
	local v = options or {}

	return {
		getFollowing = function(p: string?)
			return HttpClient.asPromise(fetchFollowingMoments(p, v.network))
		end,
		clear = function() end,
		dispose = function() end
	}
end

return createMomentsFollowingStore
