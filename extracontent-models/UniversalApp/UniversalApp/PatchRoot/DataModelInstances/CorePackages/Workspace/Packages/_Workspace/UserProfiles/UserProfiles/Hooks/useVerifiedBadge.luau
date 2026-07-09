local UserProfiles = script:FindFirstAncestor("UserProfiles")
local UserProfilesParent = UserProfiles.Parent
local SignalsReact = require(UserProfilesParent.SignalsReact)
local v4 = require(UserProfiles.Stores.VerifiedBadgeDisplayStore).get()

local function useVerifiedBadge(p1) -- line: 13
	-- upvalues: v4 (copy), SignalsReact (copy)
	local v7 = v4.getBadgeVisibilitySignal(p1.UserId)

	return (SignalsReact.useSignalState(v7))
end

return useVerifiedBadge
