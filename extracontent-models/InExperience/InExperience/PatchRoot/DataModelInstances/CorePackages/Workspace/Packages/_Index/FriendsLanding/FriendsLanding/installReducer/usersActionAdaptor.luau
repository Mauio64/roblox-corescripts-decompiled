local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama
local RoduxUsers = dependencies.RoduxUsers

local function userUpdatedFromUser(p1) -- line: 7
	-- upvalues: RoduxUsers (copy)
	return RoduxUsers.Actions.UserUpdated({
		id = p1.id,
		username = p1.name,
		displayName = p1.displayName,
		hasVerifiedBadge = p1.hasVerifiedBadge
	})
end

return {
	AddUser = function(p2) -- line: 17
		-- upvalues: userUpdatedFromUser (copy)
		return { userUpdatedFromUser(p2.user) }
	end,
	AddUsers = function(p3) -- line: 21
		-- upvalues: llama (copy), userUpdatedFromUser (copy)
		return llama.Dictionary.values(llama.Dictionary.map(p3.users, userUpdatedFromUser))
	end
}
