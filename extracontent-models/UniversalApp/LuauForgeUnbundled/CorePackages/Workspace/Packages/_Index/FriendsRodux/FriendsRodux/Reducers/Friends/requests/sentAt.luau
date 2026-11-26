local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local FriendRequestCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestCreated")
local FriendRequestDeclined = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestDeclined")
local FriendshipCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendshipCreated")

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

			local dateTimesById = {}

			for k, v8 in pairs(data) do
				dateTimesById[tostring(v8.id)] = DateTime.fromIsoDate(v8.friendRequest.sentAt)
			end

			return llama.Dictionary.join(p3, dateTimesById)
		end,
		[FriendRequestCreated.name] = function(p3, p4)
			local requesteeId = tostring(p4.requesteeId)
			local sentAt = p4.sentAt

			return llama.Dictionary.join(p3, {
				[requesteeId] = DateTime.fromIsoDate(sentAt)
			})
		end,
		[FriendRequestDeclined.name] = function(p3, p4)
			return removeIdsFromRequestsStore(p3, p4.ids)
		end,
		[FriendshipCreated.name] = function(p3, p4)
			return removeIdsFromRequestsStore(p3, { p4.payload.userId1, p4.payload.userId2 })
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function()
			return v5
		end
	})
end
