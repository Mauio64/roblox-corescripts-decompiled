local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local UserProfile = require(Parent.DataHydration.UserProfile)

local function useUserProfileInfo(n1: number) -- line: 22
	-- upvalues: React (copy), UserProfile (copy), SignalsReact (copy)
	local v7 = React.useMemo(function() -- line: 23
		-- upvalues: UserProfile (copy), n1 (copy)
		return UserProfile.getAndFetchUserInfo(n1)
	end, { n1 })
	local v8 = SignalsReact.useSignalState(v7.info)
	local v9 = SignalsReact.useSignalState(v7.status)

	return {
		displayName = v8 == nil and "" or v8.displayName,
		username = v8 == nil and "" or v8.username,
		hasVerifiedBadge = v8 ~= nil and v8.hasVerifiedBadge,
		isLoading = v9 ~= "Ready"
	}
end

return useUserProfileInfo
