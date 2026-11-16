local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local ClearNewFriendRequestsCountUpdated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/ClearNewFriendRequestsCountUpdated")

return function(p2)
	local friendsNetworking = p2.friendsNetworking
	return Rodux.createReducer(0, {
		[ClearNewFriendRequestsCountUpdated.name] = function(p3, p4): number
			return 0
		end,
		[friendsNetworking.GetNewFriendRequestsCount.Succeeded.name] = function(p3, p4)
			return p4.responseBody.count
		end,
		[friendsNetworking.ClearNewFriendRequests.Succeeded.name] = function(p3, p4): number
			return 0
		end
	})
end
