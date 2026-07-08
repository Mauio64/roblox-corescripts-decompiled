local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)
local RoduxUsers = dependencies.RoduxUsers
local convertActions = dependencies.convertActions
local usersActionAdaptor = dependencies.usersActionAdaptor
local t1 = {
	byUserId = {},
	byUsername = {}
}

return convertActions(RoduxUsers.installReducer(), usersActionAdaptor(RoduxUsers), t1)
