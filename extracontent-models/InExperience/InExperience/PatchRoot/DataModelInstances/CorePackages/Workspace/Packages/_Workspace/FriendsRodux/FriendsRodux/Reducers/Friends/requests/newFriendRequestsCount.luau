local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.roduxFriendsTypes)

return function(p1) -- line: 9
	-- upvalues: Rodux (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(0, {
		[friendsNetworking.GetNewFriendRequestsCount.Succeeded.name] = function(_, p3) -- line: 12
			return p3.responseBody.count
		end,
		[friendsNetworking.ClearNewFriendRequests.Succeeded.name] = function(_, _) -- line: 18
			return 0
		end
	})
end
