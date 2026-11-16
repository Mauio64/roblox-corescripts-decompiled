local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
require(parent.roduxFriendsTypes)

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(nil, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(_, p2)
			return p2.responseBody.nextPageCursor
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function(_, _): nil
			return nil
		end
	})
end
