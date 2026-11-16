local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SignalsReact").useSignalState

local GetExperienceInviteRetryAfterStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetExperienceInviteRetryAfterStore")

local function useIsExperienceInviteRetryBlocked(p2): boolean
	local v6 = useSignalState(GetExperienceInviteRetryAfterStore(false).getBlockedSquadId)
	return p2 ~= nil and v6 == p2
end

return useIsExperienceInviteRetryBlocked
