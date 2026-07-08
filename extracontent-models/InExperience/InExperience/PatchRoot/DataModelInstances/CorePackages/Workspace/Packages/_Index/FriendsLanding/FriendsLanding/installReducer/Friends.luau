local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local RoduxFriends = require(FriendsLanding.dependencies).RoduxFriends
local convertActions = require(script.Parent.convertActions)
local friendsActionAdaptor = require(script.Parent.friendsActionAdaptor)
local t1 = {
	countsByUserId = {},
	byUserId = {},
	requests = {
		receivedCount = 0
	}
}

return function(p1) -- line: 16
	-- upvalues: convertActions (copy), RoduxFriends (copy), friendsActionAdaptor (copy), t1 (copy)
	return convertActions(RoduxFriends.installReducer(), friendsActionAdaptor(p1), t1)
end
