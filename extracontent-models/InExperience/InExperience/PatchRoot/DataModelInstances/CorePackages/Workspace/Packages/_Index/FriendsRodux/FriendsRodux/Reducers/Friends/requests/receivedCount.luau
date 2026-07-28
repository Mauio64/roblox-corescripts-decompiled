local FriendsRodux = script:FindFirstAncestor("FriendsRodux")
local FriendsRoduxParent = FriendsRodux.Parent
local Rodux = require(FriendsRoduxParent.Rodux)
local Actions = FriendsRodux.Actions

require(FriendsRodux.roduxFriendsTypes)

local RequestReceivedCountUpdated = require(Actions.RequestReceivedCountUpdated)

return function(p1) -- line: 10
	-- upvalues: Rodux (copy), RequestReceivedCountUpdated (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(0, {
		[RequestReceivedCountUpdated.name] = function(_, p3) -- line: 14
			assert(type(p3.payload.count) == "number", "Expected count to be a number")

			return p3.payload.count
		end,
		[friendsNetworking.GetFriendRequestsCount.Succeeded.name] = function(_, p5) -- line: 20
			return p5.responseBody.count
		end
	})
end
