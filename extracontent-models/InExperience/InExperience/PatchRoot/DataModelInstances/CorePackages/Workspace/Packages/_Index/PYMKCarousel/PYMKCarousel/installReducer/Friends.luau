local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

local roduxFriends = dependencies.RoduxFriends
local convertActions = dependencies.convertActions
local friendsActionAdaptor = dependencies.friendsActionAdaptor
local llama = dependencies.llama
local friendsOmniActionAdaptor = require(script.Parent.friendsOmniActionAdaptor)
local v = {
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
	recommendations = { byUserId = {}, bySource = {} },
	friendshipStatus = {},
	friendsRankByUserId = {}
}

local v2 = roduxFriends.installReducer()

local function fn(p) -- 1 equivalent call inferred from this helper
	return llama.Dictionary.join(friendsActionAdaptor(roduxFriends), friendsOmniActionAdaptor(p))
end

return function(p)
	return convertActions(v2, fn(p), v) -- inferred equivalent call
end
