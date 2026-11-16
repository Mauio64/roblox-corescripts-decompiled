local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

local FriendRequestCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestCreated")
local FriendRequestDeclined = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestDeclined")
local FriendshipCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendshipCreated")

local removeIdsFromRequestsStore = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/removeIdsFromRequestsStore")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local v5 = {}

return function(p2)
	local friendsNetworking = p2.friendsNetworking
	local networkingBlocking = p2.networkingBlocking

	return Rodux.createReducer(v5, {
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p3, p4)
			return removeIdsFromRequestsStore(p3, p4.ids)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p3, p4)
			return removeIdsFromRequestsStore(p3, p4.ids)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p3, p4)
			local data = p4.responseBody.data

			local idSet = {}

			for k, v8 in pairs(data) do
				idSet[tostring(v8.id)] = true
			end

			return (llama.Dictionary.join(p3, idSet))
		end,
		[FriendRequestCreated.name] = function(p3, p4)
			local requesteeId = p4.requesteeId

			return llama.Dictionary.join(p3, { [tostring(requesteeId)] = true })
		end,
		[FriendRequestDeclined.name] = function(p3, p4)
			return removeIdsFromRequestsStore(p3, p4.ids)
		end,
		[FriendshipCreated.name] = function(p3, p4)
			assert(type(p4.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p4.payload.userId2) == "string", "Expected userId2 to be a string")

			return removeIdsFromRequestsStore(p3, { p4.payload.userId1, p4.payload.userId2 })
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function()
			return {}
		end,
		[networkingBlocking.BlockUserById.Succeeded.name] = function(p3, p4)
			return removeIdsFromRequestsStore(p3, { (tostring(p4.namedIds.users)) })
		end
	})
end
