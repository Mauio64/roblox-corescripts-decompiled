local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local parent = FriendsRodux.Parent
require(FriendsRodux.roduxFriendsTypes)

local Rodux = require(parent.Rodux)
local Dash = require(parent.Dash)

local v = {}
return function(p)
	local friendsNetworking = p.friendsNetworking
	local userBlockingNetworking = p.userBlockingNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.GetFollowingExists.Succeeded.name] = function(p2, p3)
			local v2 = {}
			Dash.forEach(p3.responseBody.followings, function(data)
				v2[tostring(data.userId)] = {
					isFollowed = data.isFollowed,
					isFollowing = data.isFollowing
				}
			end)
			return Dash.join(p2, v2)
		end,
		[userBlockingNetworking.BlockUserById.Succeeded.name] = function(p2, p3)
			local users = tostring(p3.namedIds.users)
			return Dash.join(p2, {
				[users] = { isFollowed = false, isFollowing = false }
			})
		end
	})
end
