local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)

local actions = parent.Actions
local FriendRequestCreated = require(actions.FriendRequestCreated)

require(parent.roduxFriendsTypes)

local llama = require(parent2.llama)

local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p2, p3)
			local data = p3.responseBody.data

			local isUnseensById = {}

			for _, v2 in pairs(data) do
				isUnseensById[tostring(v2.id)] = v2.isUnseen
			end

			return (llama.Dictionary.join(p2, isUnseensById))
		end,
		[FriendRequestCreated.name] = function(p2, p3)
			local requesteeId = p3.requesteeId

			return llama.Dictionary.join(p2, { [tostring(requesteeId)] = true })
		end,
		[friendsNetworking.ClearNewFriendRequests.Succeeded.name] = function(_, _)
			return v
		end
	})
end
