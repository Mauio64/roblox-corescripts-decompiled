local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

if require(FriendsLanding.Flags.FFlagFriendsLandingDeprecateUnusedMapToUsers) then
	return nil
end

local dependencies = require(FriendsLanding.dependencies)
local Rodux = dependencies.Rodux
local FriendsNetworking = dependencies.FriendsNetworking

return (Rodux.createReducer({}, {
	[FriendsNetworking.GetInactiveFriends.Succeeded.name] = function(_, p2) -- line: 17
		local t1 = {}

		for _, v in pairs(p2.responseBody.data) do
			t1[tostring(v.id)] = true
		end

		return t1
	end
}))
