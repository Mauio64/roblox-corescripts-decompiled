local module = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/byUserId")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/countsByUserId")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/recommendations")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/followings")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/friendshipStatus")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/friendsRankByUserId")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/contactNamesByUserId")

local v5 = {
	countsByUserId = {},
	byUserId = {},
	requests = { receivedCount = 0, newFriendRequestsCount = 0 },
	recommendations = {},
	followings = {},
	friendshipStatus = {},
	friendsRankByUserId = {},
	contactNamesByUserId = {}
}

return function(p2)
	local v6 = module(p2)
	local v7 = module2(p2)
	local v8 = module3(p2)
	local v9 = module4(p2)
	local v10 = module5(p2)
	local v11 = module6(p2)
	local v12 = module7(p2)
	local v13 = module8(p2)

	return function(p3, p4)
		local v14 = p3 or v5
		return {
			byUserId = v6(v14.byUserId, p4),
			countsByUserId = v7(v14.countsByUserId, p4),
			requests = v8(v14.requests, p4),
			recommendations = v9(v14.recommendations, p4),
			followings = v10(v14.followings, p4),
			friendshipStatus = v11(v14.friendshipStatus, p4),
			friendsRankByUserId = v12(v14.friendsRankByUserId, p4),
			contactNamesByUserId = v13(v14.contactNamesByUserId, p4)
		}
	end
end
