local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Cryo")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")
local v5 = {}

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(v5, {
		[friendsNetworking.GetFriendsCountFromUserId.Succeeded.name] = function(p3, p4)
			local users = tostring(p4.namedIds.users)
			return Cryo.Dictionary.union(p3, { [users] = p4.responseBody.count })
		end
	})
end
