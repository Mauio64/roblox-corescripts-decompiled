local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Rodux = dependencies.Rodux
local FriendsNetworking = dependencies.FriendsNetworking

return Rodux.createReducer({}, {
	[FriendsNetworking.GetUserFollowers.Succeeded.name] = function(_, p2) -- line: 10
		local t1 = {}
		local data = p2.responseBody.data

		for _, v in ipairs(data) do
			t1[tostring(v.id)] = true
		end

		return t1
	end
})
