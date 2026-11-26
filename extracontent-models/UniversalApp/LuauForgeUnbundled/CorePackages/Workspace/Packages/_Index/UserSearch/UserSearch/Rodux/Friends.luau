local RoduxFriends = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Rodux/RoduxFriends")
local convertActions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialReducerAdaptors").convertActions
local friendsActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialReducerAdaptors").friendsActionAdaptor

return convertActions(RoduxFriends.installReducer(), friendsActionAdaptor(RoduxFriends), {
	countsByUserId = {},
	byUserId = {},
	requests = { receivedCount = 0 },
	recommendations = {},
	friendshipStatus = {},
	followings = {},
	friendsRankByUserId = {}
})
