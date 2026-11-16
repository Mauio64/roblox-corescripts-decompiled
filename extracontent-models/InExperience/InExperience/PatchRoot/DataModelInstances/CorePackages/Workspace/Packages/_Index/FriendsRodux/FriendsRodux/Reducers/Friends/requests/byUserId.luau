local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)

local actions = parent.Actions
local FriendRequestCreated = require(actions.FriendRequestCreated)
local FriendRequestDeclined = require(actions.FriendRequestDeclined)
local FriendshipCreated = require(actions.FriendshipCreated)

local removeIdsFromRequestsStore = require(parent.Reducers.Friends.utils.removeIdsFromRequestsStore)
require(parent.roduxFriendsTypes)

local llama = require(parent2.llama)

local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking
	local networkingBlocking = p.networkingBlocking

	return Rodux.createReducer(v, {
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, p3.ids)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, p3.ids)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p2, p3)
			local data = p3.responseBody.data

			local idSet = {}

			for _, v2 in pairs(data) do
				idSet[tostring(v2.id)] = true
			end

			return (llama.Dictionary.join(p2, idSet))
		end,
		[FriendRequestCreated.name] = function(p2, p3)
			local requesteeId = p3.requesteeId

			return llama.Dictionary.join(p2, { [tostring(requesteeId)] = true })
		end,
		[FriendRequestDeclined.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, p3.ids)
		end,
		[FriendshipCreated.name] = function(p2, p3)
			assert(type(p3.payload.userId1) == "string", "Expected userId1 to be a string")
			assert(type(p3.payload.userId2) == "string", "Expected userId2 to be a string")

			return removeIdsFromRequestsStore(p2, { p3.payload.userId1, p3.payload.userId2 })
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function()
			return {}
		end,
		[networkingBlocking.BlockUserById.Succeeded.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, { (tostring(p3.namedIds.users)) })
		end
	})
end
