local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/SignalsReact")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Stores/VerifiedBadgeDisplayStore").get()

local function useVerifiedBadge(p2)
	local badgeVisibilitySignal = v5.getBadgeVisibilitySignal(p2.UserId)
	return (SignalsReact.useSignalState(badgeVisibilitySignal))
end

return useVerifiedBadge
