local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local promise = dependencies.Promise
local t = dependencies.t

local friendsNetworking = dependencies.FriendsNetworking

local strictInterface = t.strictInterface({
	localUserId = t.string,
	inactiveFriendsNetworkRequestStatus = t.string,
	onResolve = t.union(t.callback, t.table),
	onError = t.union(t.callback, t.table)
})

return function(callback)
	return {
		refreshPageData = function(p)
			assert(strictInterface(p))

			local v = {}
			table.insert(v, callback(friendsNetworking.GetFriendRequestsCount.API()))
			return promise.all(v):andThen(p.onResolve):catch(p.onError)
		end,
		getFriendRequestsCount = function()
			return callback(friendsNetworking.GetFriendRequestsCount.API())
		end
	}
end
