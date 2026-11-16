local SocialReducerAdaptors = script:FindFirstAncestor("SocialReducerAdaptors")
local dependencies = require(SocialReducerAdaptors.dependencies)
local llama = dependencies.llama

return function(p)
	local function userUpdatedFromUser(user)
		return p.Actions.UserUpdated({
			id = user.id,
			username = user.name,
			displayName = user.displayName,
			hasVerifiedBadge = user.hasVerifiedBadge,
			created = user.created
		})
	end

	return {
		AddUser = function(p2)
			return { userUpdatedFromUser(p2.user) }
		end,
		AddUsers = function(p2)
			return llama.Dictionary.values(llama.Dictionary.map(p2.users, userUpdatedFromUser))
		end
	}
end
