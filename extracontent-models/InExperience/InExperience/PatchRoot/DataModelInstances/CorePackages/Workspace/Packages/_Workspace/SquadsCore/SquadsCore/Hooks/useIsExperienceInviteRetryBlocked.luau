local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local GetExperienceInviteRetryAfterStore = require(SquadsCore.Stores.GetExperienceInviteRetryAfterStore)

local function useIsExperienceInviteRetryBlocked(p: string?): boolean
	local v = useSignalState(GetExperienceInviteRetryAfterStore(false).getBlockedSquadId)
	return p ~= nil and v == p
end

return useIsExperienceInviteRetryBlocked
