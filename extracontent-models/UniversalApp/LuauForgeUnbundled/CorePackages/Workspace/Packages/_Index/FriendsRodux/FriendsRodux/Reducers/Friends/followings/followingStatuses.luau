require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Dash")

local v5 = {}
return function(p2)
	local friendsNetworking = p2.friendsNetworking
	local userBlockingNetworking = p2.userBlockingNetworking

	return Rodux.createReducer(v5, {
		[friendsNetworking.GetFollowingExists.Succeeded.name] = function(p3, p4)
			local v8 = {}
			Dash.forEach(p4.responseBody.followings, function(data)
				v8[tostring(data.userId)] = {
					isFollowed = data.isFollowed,
					isFollowing = data.isFollowing
				}
			end)
			return Dash.join(p3, v8)
		end,
		[userBlockingNetworking.BlockUserById.Succeeded.name] = function(p3, p4)
			local users = tostring(p4.namedIds.users)
			return Dash.join(p3, {
				[users] = { isFollowed = false, isFollowing = false }
			})
		end
	})
end
