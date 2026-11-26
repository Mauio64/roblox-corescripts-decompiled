local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")
local RequestReceivedCountUpdated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/RequestReceivedCountUpdated")

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(0, {
		[RequestReceivedCountUpdated.name] = function(p3, p4)
			assert(type(p4.payload.count) == "number", "Expected count to be a number")

			return p4.payload.count
		end,
		[friendsNetworking.GetFriendRequestsCount.Succeeded.name] = function(p3, p4)
			return p4.responseBody.count
		end
	})
end
