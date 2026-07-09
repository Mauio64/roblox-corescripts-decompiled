local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local FriendsRoduxParent = FriendsRodux.Parent
local Rodux = require(FriendsRoduxParent.Rodux)
local Cryo = require(FriendsRoduxParent.Cryo)

require(FriendsRodux.roduxFriendsTypes)

local t1 = {}

return function(p1) -- line: 8
	-- upvalues: Rodux (copy), t1 (copy), Cryo (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.GetFriendsCountFromUserId.Succeeded.name] = function(p2, p3) -- line: 12
			-- upvalues: Cryo (copy)
			local str = tostring(p3.namedIds.users)

			return Cryo.Dictionary.union(p2, {
				[str] = p3.responseBody.count
			})
		end
	})
end
