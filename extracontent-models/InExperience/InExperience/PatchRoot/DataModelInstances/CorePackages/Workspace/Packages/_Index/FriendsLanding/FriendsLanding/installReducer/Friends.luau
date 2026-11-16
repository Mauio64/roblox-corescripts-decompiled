local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local roduxFriends = dependencies.RoduxFriends
local convertActions = require(script.Parent.convertActions)
local friendsActionAdaptor = require(script.Parent.friendsActionAdaptor)

local v = {
	countsByUserId = {},
	byUserId = {},
	requests = { receivedCount = 0 }
}

return function(p)
	return convertActions(roduxFriends.installReducer(), friendsActionAdaptor(p), v)
end
