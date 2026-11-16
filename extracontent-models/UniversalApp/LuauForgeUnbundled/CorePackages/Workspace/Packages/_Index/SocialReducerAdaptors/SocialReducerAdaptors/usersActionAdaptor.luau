local llama = require("@game/CorePackages/Workspace/Packages/_Index/SocialReducerAdaptors/SocialReducerAdaptors/dependencies").llama

return function(p2)
	local function userUpdatedFromUser(user)
		return p2.Actions.UserUpdated({
			id = user.id,
			username = user.name,
			displayName = user.displayName,
			hasVerifiedBadge = user.hasVerifiedBadge,
			created = user.created
		})
	end

	return {
		AddUser = function(p3)
			return { userUpdatedFromUser(p3.user) }
		end,
		AddUsers = function(p3)
			return llama.Dictionary.values(llama.Dictionary.map(p3.users, userUpdatedFromUser))
		end
	}
end
