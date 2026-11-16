local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)

require(parent.roduxFriendsTypes)
local actions = parent.Actions
local ClearNewFriendRequestsCountUpdated = require(actions.ClearNewFriendRequestsCountUpdated)

return function(p)
	local friendsNetworking = p.friendsNetworking
	return Rodux.createReducer(0, {
		[ClearNewFriendRequestsCountUpdated.name] = function(_, _): number
			return 0
		end,
		[friendsNetworking.GetNewFriendRequestsCount.Succeeded.name] = function(_, p2)
			return p2.responseBody.count
		end,
		[friendsNetworking.ClearNewFriendRequests.Succeeded.name] = function(_, _): number
			return 0
		end
	})
end
