local RoduxFriends = script:FindFirstAncestor("RoduxFriends")
local RoduxFriendsParent = RoduxFriends.Parent
local Rodux = require(RoduxFriendsParent.Rodux)
local Actions = RoduxFriends.Actions
local RequestReceivedCountUpdated = require(Actions.RequestReceivedCountUpdated)

return function(p1) -- line: 9
	-- upvalues: Rodux (copy), RequestReceivedCountUpdated (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(0, {
		[RequestReceivedCountUpdated.name] = function(_, p3) -- line: 13
			assert(type(p3.payload.count) == "number", "Expected count to be a number")

			return p3.payload.count
		end,
		[friendsNetworking.GetFriendRequestsCount.Succeeded.name] = function(_, p5) -- line: 19
			return p5.responseBody.count
		end
	})
end
