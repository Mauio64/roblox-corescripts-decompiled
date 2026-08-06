local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

if require(FriendsLanding.Flags.FFlagFriendsLandingDeprecateUnusedMapToUsers) then
	return nil
end

local dependencies = require(FriendsLanding.dependencies)
local Rodux = dependencies.Rodux
local FriendsNetworking = dependencies.FriendsNetworking
local llama = dependencies.llama

return (Rodux.createReducer({}, {
	[FriendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(_, p2) -- line: 18
		-- upvalues: llama (copy)
		local data = p2.responseBody.data

		return llama.Dictionary.map(data, function(p3) -- line: 20
			return p3.isDeleted, (tostring(p3.id))
		end)
	end
}))
