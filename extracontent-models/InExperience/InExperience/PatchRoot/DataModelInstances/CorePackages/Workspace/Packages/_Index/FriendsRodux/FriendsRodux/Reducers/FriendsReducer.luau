local byUserId = require(script.Parent.Friends.byUserId)
local countsByUserId = require(script.Parent.Friends.countsByUserId)
local requests = require(script.Parent.Friends.requests)
local recommendations = require(script.Parent.Friends.recommendations)
local followings = require(script.Parent.Friends.followings)
local friendshipStatus = require(script.Parent.Friends.friendshipStatus)
local friendsRankByUserId = require(script.Parent.Friends.friendsRankByUserId)
local contactNamesByUserId = require(script.Parent.Friends.contactNamesByUserId)

local v = {
	countsByUserId = {},
	byUserId = {},
	requests = { receivedCount = 0, newFriendRequestsCount = 0 },
	recommendations = {},
	followings = {},
	friendshipStatus = {},
	friendsRankByUserId = {},
	contactNamesByUserId = {}
}

return function(p)
	local v2 = byUserId(p)
	local v3 = countsByUserId(p)
	local v4 = requests(p)
	local v5 = recommendations(p)
	local v6 = followings(p)
	local v7 = friendshipStatus(p)
	local v8 = friendsRankByUserId(p)
	local v9 = contactNamesByUserId(p)

	return function(p2, p3)
		local v10 = p2 or v
		return {
			byUserId = v2(v10.byUserId, p3),
			countsByUserId = v3(v10.countsByUserId, p3),
			requests = v4(v10.requests, p3),
			recommendations = v5(v10.recommendations, p3),
			followings = v6(v10.followings, p3),
			friendshipStatus = v7(v10.friendshipStatus, p3),
			friendsRankByUserId = v8(v10.friendsRankByUserId, p3),
			contactNamesByUserId = v9(v10.contactNamesByUserId, p3)
		}
	end
end
