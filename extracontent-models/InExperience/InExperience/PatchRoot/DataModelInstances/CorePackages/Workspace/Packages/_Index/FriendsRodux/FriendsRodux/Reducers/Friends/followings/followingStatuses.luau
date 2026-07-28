local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local FriendsRoduxParent = FriendsRodux.Parent

require(FriendsRodux.roduxFriendsTypes)

local Rodux = require(FriendsRoduxParent.Rodux)
local Dash = require(FriendsRoduxParent.Dash)
local t1 = {}

return function(p1) -- line: 20
	-- upvalues: Rodux (copy), t1 (copy), Dash (copy)
	local friendsNetworking = p1.friendsNetworking
	local userBlockingNetworking = p1.userBlockingNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.GetFollowingExists.Succeeded.name] = function(p2, p3) -- line: 25
			-- upvalues: Dash (copy)
			local t2 = {}

			Dash.forEach(p3.responseBody.followings, function(p4) -- line: 27
				-- upvalues: t2 (copy)
				t2[tostring(p4.userId)] = {
					isFollowed = p4.isFollowed,
					isFollowing = p4.isFollowing
				}
			end)

			return Dash.join(p2, t2)
		end,
		[userBlockingNetworking.BlockUserById.Succeeded.name] = function(p5, p6) -- line: 36
			-- upvalues: Dash (copy)
			local str = tostring(p6.namedIds.users)

			return Dash.join(p5, {
				[str] = {
					isFollowed = false,
					isFollowing = false
				}
			})
		end
	})
end
