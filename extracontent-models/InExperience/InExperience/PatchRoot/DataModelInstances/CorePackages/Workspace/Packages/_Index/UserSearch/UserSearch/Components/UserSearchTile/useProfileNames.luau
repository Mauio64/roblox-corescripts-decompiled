local parent = script:FindFirstAncestor("UserSearch").Parent

local UserProfiles = require(parent.UserProfiles)

local function useProfileNames(p)
	local v = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { p.userId },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local v2

	if v.data then
		v2 = UserProfiles.Selectors.getUsernameFromId(v.data, p.userId)
	end

	local username

	if v2 then
		username = UserProfiles.Formatters.formatUsername(v2)
	end

	local combinedName

	if v.data then
		combinedName = UserProfiles.Selectors.getCombinedNameFromId(v.data, p.userId)
	end

	return { username = username, combinedName = combinedName }
end

return useProfileNames
