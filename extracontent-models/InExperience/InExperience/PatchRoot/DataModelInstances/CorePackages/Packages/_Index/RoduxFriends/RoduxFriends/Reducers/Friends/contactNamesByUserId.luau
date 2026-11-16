local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
local llama = require(parent2.llama)

require(parent.roduxFriendsTypes)

local actions = parent.Actions
local FriendRequestCreated = require(actions.FriendRequestCreated)

local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p2, p3)
			local data = p3.responseBody.data

			local contactNamesById = {}

			for _, v2 in pairs(data) do
				contactNamesById[tostring(v2.id)] = v2.friendRequest.contactName
			end

			return llama.Dictionary.join(p2, contactNamesById)
		end,
		[FriendRequestCreated.name] = function(p2, p3)
			local requesteeId = tostring(p3.requesteeId)
			local contactName = p3.contactName

			return llama.Dictionary.join(p2, { [requesteeId] = contactName })
		end
	})
end
