local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.roduxFriendsTypes)

return function(p1) -- line: 9
	-- upvalues: Rodux (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(nil, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(_, p3) -- line: 13
			return p3.responseBody.nextPageCursor
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function(_, _) -- line: 19
			return nil
		end
	})
end
