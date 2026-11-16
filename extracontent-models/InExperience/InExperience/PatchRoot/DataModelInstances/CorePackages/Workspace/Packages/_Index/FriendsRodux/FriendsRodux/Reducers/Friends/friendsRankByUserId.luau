local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
local llama = require(parent2.llama)

require(parent.roduxFriendsTypes)

local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p2, data)
			if not (data.queryArgs and data.queryArgs.userSort) then
				return p2
			end

			local users = tostring(data.namedIds.users)
			local data2 = data.responseBody.data or {}

			local mapped = llama.Dictionary.map(data2, function(p3, p4)
				return p4, (tostring(p3.id))
			end)

			return llama.Dictionary.join(p2, { [users] = mapped })
		end
	})
end
