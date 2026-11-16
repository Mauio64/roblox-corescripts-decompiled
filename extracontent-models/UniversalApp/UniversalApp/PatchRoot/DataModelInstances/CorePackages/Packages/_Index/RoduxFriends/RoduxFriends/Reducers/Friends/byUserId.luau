local RoduxFriends = script:FindFirstAncestor("RoduxFriends")
local parent = RoduxFriends.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)

local Actions = RoduxFriends.Actions
local FriendshipCreated = require(Actions.FriendshipCreated)
local FriendshipDestroyed = require(Actions.FriendshipDestroyed)

local addUser = require(script.Parent.utils.addUser)
local removeUser = require(script.Parent.utils.removeUser)
local setFriendshipsInStore = require(script.Parent.utils.setFriendshipsInStore)
local removeTargetUserFriendshipInStore = require(script.Parent.utils.removeTargetUserFriendshipInStore)

local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[FriendshipCreated.name] = function(p2, p3)
			assert(type(p3.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p3.payload.userId2) == "string", "Expected userId2 to be a string")

			return llama.Dictionary.join(p2, {
				[p3.payload.userId1] = addUser(p2[p3.payload.userId1], p3.payload.userId2),
				[p3.payload.userId2] = addUser(p2[p3.payload.userId2], p3.payload.userId1)
			})
		end,
		[FriendshipDestroyed.name] = function(p2, p3)
			assert(type(p3.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p3.payload.userId2) == "string", "Expected userId2 to be a string")

			return llama.Dictionary.join(p2, {
				[p3.payload.userId1] = removeUser(p2[p3.payload.userId1], p3.payload.userId2),
				[p3.payload.userId2] = removeUser(p2[p3.payload.userId2], p3.payload.userId1)
			})
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p2, p3)
			return setFriendshipsInStore(p2, p3)
		end,
		[friendsNetworking.UnfriendTargetUserId.Succeeded.name] = function(p2, p3)
			return removeTargetUserFriendshipInStore(p2, p3)
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			local v2 = tostring(p3.ids[1])
			local currentUserId = tostring(p3.additionalData.currentUserId)

			return llama.Dictionary.join(p2, {
				[v2] = addUser(p2[v2], currentUserId),
				[currentUserId] = addUser(p2[currentUserId], v2)
			})
		end
	})
end
