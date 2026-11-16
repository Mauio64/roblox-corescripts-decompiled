local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local parent = FriendsRodux.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)
require(FriendsRodux.roduxFriendsTypes)
local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.GetFriendsCountFromUserId.Succeeded.name] = function(p2, p3)
			local users = tostring(p3.namedIds.users)
			return Cryo.Dictionary.union(p2, { [users] = p3.responseBody.count })
		end
	})
end
