local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

local FriendRequestCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestCreated")
local FriendRequestDeclined = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestDeclined")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")
local removeIdsFromRequestsStore = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/removeIdsFromRequestsStore")

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

			local senderNicknamesById = {}

			for k, v8 in pairs(data) do
				senderNicknamesById[tostring(v8.id)] = v8.friendRequest.senderNickname
			end

			return (llama.Dictionary.join(p3, senderNicknamesById))
		end,
		[FriendRequestCreated.name] = function(p3, p4)
			local requesteeId = p4.requesteeId
			local senderNickname = p4.senderNickname

			return llama.Dictionary.join(p3, {
				[tostring(requesteeId)] = senderNickname
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
