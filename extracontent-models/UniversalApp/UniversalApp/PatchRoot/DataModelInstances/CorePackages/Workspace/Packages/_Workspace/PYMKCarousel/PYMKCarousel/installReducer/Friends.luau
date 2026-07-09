local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local RoduxFriends = dependencies.RoduxFriends
local convertActions = dependencies.convertActions
local friendsActionAdaptor = dependencies.friendsActionAdaptor
local llama = dependencies.llama
local friendsOmniActionAdaptor = require(script.Parent.friendsOmniActionAdaptor)
local t1 = {
	countsByUserId = {},
	byUserId = {},
	requests = {
		receivedCount = 0,
		newFriendRequestsCount = 0,
		byUserId = {},
		mutualFriends = {},
		sentAt = {},
		sourceUniverseIds = {}
	},
	recommendations = {
		byUserId = {},
		bySource = {}
	},
	friendshipStatus = {},
	friendsRankByUserId = {}
}
local v9 = RoduxFriends.installReducer()

return function(p1) -- line: 34
	-- upvalues: convertActions (copy), v9 (copy), llama (copy), friendsActionAdaptor (copy), RoduxFriends (copy), friendsOmniActionAdaptor (copy), t1 (copy)
	return convertActions(v9, llama.Dictionary.join(friendsActionAdaptor(RoduxFriends), friendsOmniActionAdaptor(p1)), t1)
end
