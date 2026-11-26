local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local FriendshipCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendshipCreated")
local FriendshipDestroyed = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendshipDestroyed")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local addUser = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/addUser")
local removeUser = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/removeUser")
local setFriendshipsInStore = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/setFriendshipsInStore")
local removeTargetUserFriendshipInStore = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/removeTargetUserFriendshipInStore")

local v5 = {}

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(v5, {
		[FriendshipCreated.name] = function(p3, p4)
			assert(type(p4.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p4.payload.userId2) == "string", "Expected userId2 to be a string")

			return llama.Dictionary.join(p3, {
				[p4.payload.userId1] = addUser(p3[p4.payload.userId1], p4.payload.userId2),
				[p4.payload.userId2] = addUser(p3[p4.payload.userId2], p4.payload.userId1)
			})
		end,
		[FriendshipDestroyed.name] = function(p3, p4)
			assert(type(p4.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p4.payload.userId2) == "string", "Expected userId2 to be a string")

			return llama.Dictionary.join(p3, {
				[p4.payload.userId1] = removeUser(p3[p4.payload.userId1], p4.payload.userId2),
				[p4.payload.userId2] = removeUser(p3[p4.payload.userId2], p4.payload.userId1)
			})
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p3, p4)
			return setFriendshipsInStore(p3, p4)
		end,
		[friendsNetworking.UnfriendTargetUserId.Succeeded.name] = function(p3, p4)
			return removeTargetUserFriendshipInStore(p3, p4)
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p3, p4)
			local v8 = tostring(p4.ids[1])
			local currentUserId = tostring(p4.additionalData.currentUserId)

			return llama.Dictionary.join(p3, {
				[v8] = addUser(p3[v8], currentUserId),
				[currentUserId] = addUser(p3[currentUserId], v8)
			})
		end
	})
end
