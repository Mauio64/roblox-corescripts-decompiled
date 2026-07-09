local SocialReducerAdaptors = script:FindFirstAncestor("SocialReducerAdaptors")
local llama = require(SocialReducerAdaptors.dependencies).llama

return function(p1) -- line: 16
	-- upvalues: llama (copy)
	local function userUpdatedFromUser(t1: {[any]: any}) -- line: 17
		-- upvalues: p1 (copy)
		return p1.Actions.UserUpdated({
			id = t1.id,
			username = t1.name,
			displayName = t1.displayName,
			hasVerifiedBadge = t1.hasVerifiedBadge,
			created = t1.created
		})
	end

	return {
		AddUser = function(p2) -- line: 28
			-- upvalues: userUpdatedFromUser (copy)
			return { userUpdatedFromUser(p2.user) }
		end,
		AddUsers = function(p3) -- line: 32
			-- upvalues: llama (copy), userUpdatedFromUser (copy)
			return llama.Dictionary.values(llama.Dictionary.map(p3.users, userUpdatedFromUser))
		end
	}
end
