local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsNetworking = require(FriendsLanding.dependencies).FriendsNetworking

return function(p1) -- line: 6
	-- upvalues: FriendsNetworking (copy)
	return {
		fetchFriends = function(p2) -- line: 8
			-- upvalues: p1 (copy), FriendsNetworking (copy)
			return p1(FriendsNetworking.GetFriendsFromUserId.API(p2))
		end,
		getFriendRequestsCount = function() -- line: 11
			-- upvalues: p1 (copy), FriendsNetworking (copy)
			return p1(FriendsNetworking.GetFriendRequestsCount.API())
		end,
		getInactiveFriends = function(p3) -- line: 14
			-- upvalues: p1 (copy), FriendsNetworking (copy)
			return p1(FriendsNetworking.GetInactiveFriends.API(p3))
		end,
		unfriendTargetUser = function(p4) -- line: 17
			-- upvalues: p1 (copy), FriendsNetworking (copy)
			return p1(FriendsNetworking.UnfriendTargetUserId.API(p4))
		end
	}
end
