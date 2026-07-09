local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local mapToUsers = require(FriendsLanding.Friends.mapToUsers)

return function(p1, _) -- line: 4
	-- upvalues: mapToUsers (copy)
	return {
		localUserId = p1.LocalUserId,
		friends = mapToUsers(p1)(p1.LocalUserId)
	}
end
