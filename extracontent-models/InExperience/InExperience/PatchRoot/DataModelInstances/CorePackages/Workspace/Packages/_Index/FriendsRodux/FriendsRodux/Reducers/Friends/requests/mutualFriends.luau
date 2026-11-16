local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)

local actions = parent.Actions
local FriendRequestCreated = require(actions.FriendRequestCreated)
local FriendRequestDeclined = require(actions.FriendRequestDeclined)

local removeIdsFromRequestsStore = require(parent.Reducers.Friends.utils.removeIdsFromRequestsStore)
require(parent.roduxFriendsTypes)

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

			local values = {}

			for _, v2 in pairs(data) do
				if v2.mutualFriendsList then
					values[tostring(v2.id)] = llama.List.map(v2.mutualFriendsList, function(p4)
						return (tostring(p4))
					end)
				end
			end

			return (llama.Dictionary.join(p2, values))
		end,
		[FriendRequestCreated.name] = function(p2, p3)
			local requesteeId = p3.requesteeId
			local mutualFriends = p3.mutualFriends

			return llama.Dictionary.join(p2, {
				[tostring(requesteeId)] = llama.List.map(mutualFriends, function(p4)
					return (tostring(p4))
				end)
			})
		end,
		[FriendRequestDeclined.name] = function(p2, p3)
			return removeIdsFromRequestsStore(p2, p3.ids)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function()
			return {}
		end
	})
end
