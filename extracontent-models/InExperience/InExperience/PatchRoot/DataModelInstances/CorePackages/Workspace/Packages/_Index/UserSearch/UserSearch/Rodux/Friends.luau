local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local RoduxFriends = require(UserSearch.Rodux.RoduxFriends)
local SocialReducerAdaptors = require(parent.SocialReducerAdaptors)
local convertActions = SocialReducerAdaptors.convertActions
local SocialReducerAdaptors2 = require(parent.SocialReducerAdaptors)
local friendsActionAdaptor = SocialReducerAdaptors2.friendsActionAdaptor

return convertActions(RoduxFriends.installReducer(), friendsActionAdaptor(RoduxFriends), {
	countsByUserId = {},
	byUserId = {},
	requests = { receivedCount = 0 },
	recommendations = {},
	friendshipStatus = {},
	followings = {},
	friendsRankByUserId = {}
})
