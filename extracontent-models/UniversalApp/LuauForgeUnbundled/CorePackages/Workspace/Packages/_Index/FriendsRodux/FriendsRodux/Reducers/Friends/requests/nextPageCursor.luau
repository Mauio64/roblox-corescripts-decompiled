local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(nil, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p3, p4)
			return p4.responseBody.nextPageCursor
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function(p3, p4): nil
			return nil
		end
	})
end
