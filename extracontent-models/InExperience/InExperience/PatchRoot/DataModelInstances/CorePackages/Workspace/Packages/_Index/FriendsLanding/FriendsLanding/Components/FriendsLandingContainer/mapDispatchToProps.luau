local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local friendsNetworking = dependencies.FriendsNetworking

local parent = FriendsLanding.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateFriendshipStatusesRemainingActions = SharedFlags.FFlagMigrateFriendshipStatusesRemainingActions

return function(callback)
	return {
		fetchFriends = function(p)
			return callback(friendsNetworking.GetFriendsFromUserId.API(p))
		end,
		getFriendRequestsCount = function()
			return callback(friendsNetworking.GetFriendRequestsCount.API())
		end,
		getInactiveFriends = function(p)
			return callback(friendsNetworking.GetInactiveFriends.API(p))
		end,
		unfriendTargetUser = not FFlagMigrateFriendshipStatusesRemainingActions and function(p)
			return callback(friendsNetworking.UnfriendTargetUserId.API(p))
		end or nil
	}
end
