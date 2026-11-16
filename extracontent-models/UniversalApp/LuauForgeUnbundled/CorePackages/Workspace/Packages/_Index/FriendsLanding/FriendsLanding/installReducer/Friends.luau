local roduxFriends = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies").RoduxFriends
local convertActions = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/installReducer/convertActions")
local friendsActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/installReducer/friendsActionAdaptor")

local v5 = {
	countsByUserId = {},
	byUserId = {},
	requests = { receivedCount = 0 }
}

return function(p2)
	return convertActions(roduxFriends.installReducer(), friendsActionAdaptor(p2), v5)
end
