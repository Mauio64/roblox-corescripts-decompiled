local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local parent = FriendsRodux.Parent
local Rodux = require(parent.Rodux)
local Actions = FriendsRodux.Actions
require(FriendsRodux.roduxFriendsTypes)
local RequestReceivedCountUpdated = require(Actions.RequestReceivedCountUpdated)

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(0, {
		[RequestReceivedCountUpdated.name] = function(_, p2)
			assert(type(p2.payload.count) == "number", "Expected count to be a number")

			return p2.payload.count
		end,
		[friendsNetworking.GetFriendRequestsCount.Succeeded.name] = function(_, p2)
			return p2.responseBody.count
		end
	})
end
