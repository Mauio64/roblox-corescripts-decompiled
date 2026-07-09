local SocialTabState = script:FindFirstAncestor("SocialTabState")
local dependencies = require(SocialTabState.dependencies)
local Rodux = dependencies.Rodux
local llama = dependencies.llama

return Rodux.createReducer({}, {
	SetUserMembershipType = function(p1, p2) -- line: 7
		-- upvalues: llama (copy)
		return llama.Dictionary.set(p1, p2.userId, p2.membershipType ~= Enum.MembershipType.None)
	end
})
