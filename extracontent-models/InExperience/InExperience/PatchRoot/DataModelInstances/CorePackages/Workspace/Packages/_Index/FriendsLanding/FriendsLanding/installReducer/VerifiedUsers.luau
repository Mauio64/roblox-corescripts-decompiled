local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Rodux = dependencies.Rodux
local llama = dependencies.llama
local FriendsNetworking = dependencies.FriendsNetworking

local function v6(t1: {[any]: any}, t2: {[any]: any}) -- line: 17
	-- upvalues: llama (copy)
	local t3 = {}

	for _, v in ipairs(t2) do
		t3[tostring(v.id)] = not not v.hasVerifiedBadge or llama.None
	end

	return llama.Dictionary.join(t1, t3)
end

return Rodux.createReducer({}, {
	[FriendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(t4: {[any]: any}, p1) -- line: 28
		-- upvalues: v6 (copy)
		return v6(t4, p1.responseBody.data)
	end
})
