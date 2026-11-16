local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)

local actions = parent.Actions
local FriendRequestCreated = require(actions.FriendRequestCreated)
local FriendRequestDeclined = require(actions.FriendRequestDeclined)

require(parent.roduxFriendsTypes)
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

			local senderNicknamesById = {}

			for _, v2 in pairs(data) do
				senderNicknamesById[tostring(v2.id)] = v2.friendRequest.senderNickname
			end

			return (llama.Dictionary.join(p2, senderNicknamesById))
		end,
		[FriendRequestCreated.name] = function(p2, p3)
			local requesteeId = p3.requesteeId
			local senderNickname = p3.senderNickname

			return llama.Dictionary.join(p2, { [tostring(requesteeId)] = senderNickname })
		end,
		[FriendRequestDeclined.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, p3.ids)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function()
			return {}
		end
	})
end
