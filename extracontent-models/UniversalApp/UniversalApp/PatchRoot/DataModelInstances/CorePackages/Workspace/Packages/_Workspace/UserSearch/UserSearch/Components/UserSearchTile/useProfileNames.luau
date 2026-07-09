local Parent = script:FindFirstAncestor("UserSearch").Parent
local UserProfiles = require(Parent.UserProfiles)

local function useProfileNames(t1: {[any]: any}) -- line: 15
	-- upvalues: UserProfiles (copy)
	local v5 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { t1.userId },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local v6 = if not v5.data then nil else UserProfiles.Selectors.getUsernameFromId(v5.data, t1.userId)
	local v7 = if not v6 then nil else UserProfiles.Formatters.formatUsername(v6)
	local v8 = if not v5.data then nil else UserProfiles.Selectors.getCombinedNameFromId(v5.data, t1.userId)

	return {
		username = v7,
		combinedName = v8
	}
end

return useProfileNames
