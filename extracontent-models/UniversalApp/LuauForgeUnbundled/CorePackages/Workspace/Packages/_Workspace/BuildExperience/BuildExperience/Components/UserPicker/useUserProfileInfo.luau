local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local UserProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UserProfile")

local function useUserProfileInfo(p2)
	local v5 = React.useMemo(function()
		return UserProfile.getAndFetchUserInfo(p2)
	end, { p2 })

	local v6 = SignalsReact.useSignalState(v5.info)
	local v7 = SignalsReact.useSignalState(v5.status)

	return {
		displayName = v6 == nil and "" or v6.displayName,
		username = v6 == nil and "" or v6.username,
		hasVerifiedBadge = v6 ~= nil and v6.hasVerifiedBadge,
		isLoading = v7 ~= "Ready"
	}
end

return useUserProfileInfo
