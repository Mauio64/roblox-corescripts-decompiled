local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

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
		refreshPageData = function(p2)
			assert(strictInterface(p2))

			local v5 = {}
			table.insert(v5, callback(friendsNetworking.GetFriendRequestsCount.API()))
			return promise.all(v5):andThen(p2.onResolve):catch(p2.onError)
		end,
		getFriendRequestsCount = function()
			return callback(friendsNetworking.GetFriendRequestsCount.API())
		end
	}
end
