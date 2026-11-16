local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local rodux = dependencies.Rodux
local friendsNetworking = dependencies.FriendsNetworking

return rodux.createReducer({}, {
	[friendsNetworking.GetUserFollowers.Succeeded.name] = function(_, p)
		local data = p.responseBody.data
		local idSet = {}

		for _, v in ipairs(data) do
			idSet[tostring(v.id)] = true
		end

		return idSet
	end
})
