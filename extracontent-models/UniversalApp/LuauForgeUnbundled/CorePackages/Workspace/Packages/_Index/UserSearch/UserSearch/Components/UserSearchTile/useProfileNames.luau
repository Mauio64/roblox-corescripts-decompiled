local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserProfiles")

local function useProfileNames(p2)
	local v5 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { p2.userId },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})

	local v6 = if v5.data then UserProfiles.Selectors.getUsernameFromId(v5.data, p2.userId) else nil

	local v7 = if v6 then UserProfiles.Formatters.formatUsername(v6) else nil

	local v8 = if v5.data then UserProfiles.Selectors.getCombinedNameFromId(v5.data, p2.userId) else nil

	return { username = v7, combinedName = v8 }
end

return useProfileNames
