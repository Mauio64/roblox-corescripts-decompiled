local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Promise = dependencies.Promise
local t = dependencies.t
local FriendsNetworking = dependencies.FriendsNetworking
local v6 = t.strictInterface({
	localUserId = t.string,
	inactiveFriendsNetworkRequestStatus = t.string,
	onResolve = t.union(t.callback, t.table),
	onError = t.union(t.callback, t.table)
})

return function(p1) -- line: 16
	-- upvalues: v6 (copy), FriendsNetworking (copy), Promise (copy)
	return {
		refreshPageData = function(p2) -- line: 18
			-- upvalues: v6 (copy), p1 (copy), FriendsNetworking (copy), Promise (copy)
			assert(v6(p2))

			local t1 = {}

			table.insert(t1, p1(FriendsNetworking.GetFriendRequestsCount.API()))

			return Promise.all(t1):andThen(p2.onResolve):catch(p2.onError)
		end,
		getFriendRequestsCount = function() -- line: 26
			-- upvalues: p1 (copy), FriendsNetworking (copy)
			return p1(FriendsNetworking.GetFriendRequestsCount.API())
		end
	}
end
