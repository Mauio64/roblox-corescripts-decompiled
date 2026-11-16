local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)

require(parent.roduxFriendsTypes)

local actions = parent.Actions
local FriendRequestCreated = require(actions.FriendRequestCreated)
local FriendRequestDeclined = require(actions.FriendRequestDeclined)
local FriendshipCreated = require(actions.FriendshipCreated)

local removeIdsFromRequestsStore = require(parent.Reducers.Friends.utils.removeIdsFromRequestsStore)

local llama = require(parent2.llama)

local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, p3.ids)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, p3.ids)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p2, p3)
			local data = p3.responseBody.data

			local dateTimesById = {}

			for _, v2 in pairs(data) do
				dateTimesById[tostring(v2.id)] = DateTime.fromIsoDate(v2.friendRequest.sentAt)
			end

			return llama.Dictionary.join(p2, dateTimesById)
		end,
		[FriendRequestCreated.name] = function(p2, p3)
			local requesteeId = tostring(p3.requesteeId)
			local sentAt = p3.sentAt

			return llama.Dictionary.join(p2, { [requesteeId] = DateTime.fromIsoDate(sentAt) })
		end,
		[FriendRequestDeclined.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, p3.ids)
		end,
		[FriendshipCreated.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, { p3.payload.userId1, p3.payload.userId2 })
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function()
			return v
		end
	})
end
