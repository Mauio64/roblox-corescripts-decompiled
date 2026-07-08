local byUserId = require(script.Parent.Friends.byUserId)
local countsByUserId = require(script.Parent.Friends.countsByUserId)
local requests = require(script.Parent.Friends.requests)
local recommendations = require(script.Parent.Friends.recommendations)
local friendshipStatus = require(script.Parent.Friends.friendshipStatus)
local friendsRankByUserId = require(script.Parent.Friends.friendsRankByUserId)
local contactNamesByUserId = require(script.Parent.Friends.contactNamesByUserId)
local t1 = {
	countsByUserId = {},
	byUserId = {},
	requests = {
		receivedCount = 0
	},
	recommendations = {},
	friendshipStatus = {},
	friendsRankByUserId = {},
	contactNamesByUserId = {}
}

return function(p1) -- line: 21
	-- upvalues: t1 (copy), byUserId (copy), countsByUserId (copy), requests (copy), recommendations (copy), friendshipStatus (copy), friendsRankByUserId (copy), contactNamesByUserId (copy)
	return function(p2, p3) -- line: 22
		-- upvalues: t1 (copy), byUserId (copy), p1 (copy), countsByUserId (copy), requests (copy), recommendations (copy), friendshipStatus (copy), friendsRankByUserId (copy), contactNamesByUserId (copy)
		local v12 = p2 or t1
		local v13 = byUserId(p1)
		local v14 = countsByUserId(p1)
		local v15 = requests(p1)
		local v16 = recommendations(p1)
		local v17 = friendshipStatus(p1)
		local v18 = friendsRankByUserId(p1)
		local v19 = contactNamesByUserId(p1)

		return {
			byUserId = v13(v12.byUserId, p3),
			countsByUserId = v14(p2, p3),
			requests = v15(v12.requests, p3),
			recommendations = v16(v12.recommendations, p3),
			friendshipStatus = v17(v12.friendshipStatus, p3),
			friendsRankByUserId = v18(v12.friendsRankByUserId, p3),
			contactNamesByUserId = v19(v12.contactNamesByUserId, p3)
		}
	end
end
