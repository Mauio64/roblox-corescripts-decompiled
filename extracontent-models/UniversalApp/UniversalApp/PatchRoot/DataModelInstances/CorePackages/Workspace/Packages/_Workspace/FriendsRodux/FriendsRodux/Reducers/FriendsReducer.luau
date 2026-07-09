local byUserId = require(script.Parent.Friends.byUserId)
local countsByUserId = require(script.Parent.Friends.countsByUserId)
local requests = require(script.Parent.Friends.requests)
local recommendations = require(script.Parent.Friends.recommendations)
local followings = require(script.Parent.Friends.followings)
local friendshipStatus = require(script.Parent.Friends.friendshipStatus)
local friendsRankByUserId = require(script.Parent.Friends.friendsRankByUserId)
local contactNamesByUserId = require(script.Parent.Friends.contactNamesByUserId)
local t1 = {
	countsByUserId = {},
	byUserId = {},
	requests = {
		receivedCount = 0,
		newFriendRequestsCount = 0
	},
	recommendations = {},
	followings = {},
	friendshipStatus = {},
	friendsRankByUserId = {},
	contactNamesByUserId = {}
}

return function(p1) -- line: 24
	-- upvalues: byUserId (copy), countsByUserId (copy), requests (copy), recommendations (copy), followings (copy), friendshipStatus (copy), friendsRankByUserId (copy), contactNamesByUserId (copy), t1 (copy)
	local v11 = byUserId(p1)
	local v12 = countsByUserId(p1)
	local v13 = requests(p1)
	local v14 = recommendations(p1)
	local v15 = followings(p1)
	local v16 = friendshipStatus(p1)
	local v17 = friendsRankByUserId(p1)
	local v18 = contactNamesByUserId(p1)

	return function(p2, p3) -- line: 34
		-- upvalues: t1 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy)
		local v21 = p2 or t1

		return {
			byUserId = v11(v21.byUserId, p3),
			countsByUserId = v12(v21.countsByUserId, p3),
			requests = v13(v21.requests, p3),
			recommendations = v14(v21.recommendations, p3),
			followings = v15(v21.followings, p3),
			friendshipStatus = v16(v21.friendshipStatus, p3),
			friendsRankByUserId = v17(v21.friendsRankByUserId, p3),
			contactNamesByUserId = v18(v21.contactNamesByUserId, p3)
		}
	end
end
