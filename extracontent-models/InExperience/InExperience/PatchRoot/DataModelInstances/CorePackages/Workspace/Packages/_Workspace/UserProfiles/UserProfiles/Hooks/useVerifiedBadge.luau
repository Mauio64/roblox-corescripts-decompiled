local UserProfiles = script:FindFirstAncestor("UserProfiles")
local parent = UserProfiles.Parent
local SignalsReact = require(parent.SignalsReact)
local VerifiedBadgeDisplayStore = require(UserProfiles.Stores.VerifiedBadgeDisplayStore)
local v = VerifiedBadgeDisplayStore.get()

local function useVerifiedBadge(p)
	local badgeVisibilitySignal = v.getBadgeVisibilitySignal(p.UserId)
	return (SignalsReact.useSignalState(badgeVisibilitySignal))
end

return useVerifiedBadge
