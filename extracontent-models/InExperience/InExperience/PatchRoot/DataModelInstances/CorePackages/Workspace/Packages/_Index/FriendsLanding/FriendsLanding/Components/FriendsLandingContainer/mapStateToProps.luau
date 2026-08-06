local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local mapToUsers = require(FriendsLanding.Friends.mapToUsers)
local FFlagFriendsLandingDeprecateUnusedMapToUsers = require(FriendsLanding.Flags.FFlagFriendsLandingDeprecateUnusedMapToUsers)

return function(p1, _) -- line: 7
	-- upvalues: FFlagFriendsLandingDeprecateUnusedMapToUsers (copy), mapToUsers (copy)
	return {
		localUserId = p1.LocalUserId,
		friends = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then mapToUsers(p1)(p1.LocalUserId) else nil
	}
end
