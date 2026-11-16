local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local UserProfile = require(parent.DataHydration.UserProfile)

local function useUserProfileInfo(p: number)
	local v = React.useMemo(function()
		return UserProfile.getAndFetchUserInfo(p)
	end, { p })

	local v2 = SignalsReact.useSignalState(v.info)
	local v3 = SignalsReact.useSignalState(v.status)

	return {
		displayName = v2 == nil and "" or v2.displayName,
		username = v2 == nil and "" or v2.username,
		hasVerifiedBadge = v2 ~= nil and v2.hasVerifiedBadge,
		isLoading = v3 ~= "Ready"
	}
end

return useUserProfileInfo
