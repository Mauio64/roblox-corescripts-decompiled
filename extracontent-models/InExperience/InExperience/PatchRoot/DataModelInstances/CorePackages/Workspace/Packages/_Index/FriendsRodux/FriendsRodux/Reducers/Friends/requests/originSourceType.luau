local parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(parent.Rodux)
local parent2 = script.Parent.Parent.Parent.Parent

local getDeepValue = require(parent2.getDeepValue)
local llama = require(parent.llama)

local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(_, p2)
			local data = p2.responseBody.data
			return (llama.Dictionary.map(data, function(p3)
				return getDeepValue(p3, "friendRequest.originSourceType"), (tostring(p3.id))
			end))
		end
	})
end
