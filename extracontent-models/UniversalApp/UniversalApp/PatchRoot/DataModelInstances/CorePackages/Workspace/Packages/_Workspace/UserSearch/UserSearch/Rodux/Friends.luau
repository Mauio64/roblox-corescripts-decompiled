local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local RoduxFriends = require(UserSearch.Rodux.RoduxFriends)
local convertActions = require(UserSearchParent.SocialReducerAdaptors).convertActions
local friendsActionAdaptor = require(UserSearchParent.SocialReducerAdaptors).friendsActionAdaptor
local t1 = {
	countsByUserId = {},
	byUserId = {},
	requests = {
		receivedCount = 0
	},
	recommendations = {},
	friendshipStatus = {},
	followings = {},
	friendsRankByUserId = {}
}

return convertActions(RoduxFriends.installReducer(), friendsActionAdaptor(RoduxFriends), t1)
