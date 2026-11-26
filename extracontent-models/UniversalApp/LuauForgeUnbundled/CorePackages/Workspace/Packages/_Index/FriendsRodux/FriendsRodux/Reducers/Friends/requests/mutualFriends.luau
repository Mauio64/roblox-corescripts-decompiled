local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

local FriendRequestCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestCreated")
local FriendRequestDeclined = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestDeclined")

local removeIdsFromRequestsStore = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/removeIdsFromRequestsStore")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local v5 = {}

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(v5, {
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p3, p4)
			return removeIdsFromRequestsStore(p3, p4.ids)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p3, p4)
			return removeIdsFromRequestsStore(p3, p4.ids)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p3, p4)
			local data = p4.responseBody.data

			local values = {}

			for k, v8 in pairs(data) do
				if v8.mutualFriendsList then
					values[tostring(v8.id)] = llama.List.map(v8.mutualFriendsList, function(p5)
						return (tostring(p5))
					end)
				end
			end

			return (llama.Dictionary.join(p3, values))
		end,
		[FriendRequestCreated.name] = function(p3, p4)
			local requesteeId = p4.requesteeId
			local mutualFriends = p4.mutualFriends

			return llama.Dictionary.join(p3, {
				[tostring(requesteeId)] = llama.List.map(mutualFriends, function(p5)
					return (tostring(p5))
				end)
			})
		end,
		[FriendRequestDeclined.name] = function(p3, p4)
			return removeIdsFromRequestsStore(p3, p4.ids)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function()
			return {}
		end
	})
end
