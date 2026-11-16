local byUserId = require(script.Parent.Friends.byUserId)
local countsByUserId = require(script.Parent.Friends.countsByUserId)
local requests = require(script.Parent.Friends.requests)
local recommendations = require(script.Parent.Friends.recommendations)
local friendshipStatus = require(script.Parent.Friends.friendshipStatus)
local friendsRankByUserId = require(script.Parent.Friends.friendsRankByUserId)
local contactNamesByUserId = require(script.Parent.Friends.contactNamesByUserId)

local v = {
	countsByUserId = {},
	byUserId = {},
	requests = { receivedCount = 0 },
	recommendations = {},
	friendshipStatus = {},
	friendsRankByUserId = {},
	contactNamesByUserId = {}
}

return function(p)
	return function(p2, p3)
		local v2 = p2 or v
		local v3 = byUserId(p)
		local v4 = countsByUserId(p)
		local v5 = requests(p)
		local v6 = recommendations(p)
		local v7 = friendshipStatus(p)
		local v8 = friendsRankByUserId(p)
		local v9 = contactNamesByUserId(p)

		return {
			byUserId = v3(v2.byUserId, p3),
			countsByUserId = v4(p2, p3),
			requests = v5(v2.requests, p3),
			recommendations = v6(v2.recommendations, p3),
			friendshipStatus = v7(v2.friendshipStatus, p3),
			friendsRankByUserId = v8(v2.friendsRankByUserId, p3),
			contactNamesByUserId = v9(v2.contactNamesByUserId, p3)
		}
	end
end
