local parent = script:FindFirstAncestor("SquadsCore").Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local useIsUserPartyVoiceEligible = require(script.Parent.useIsUserPartyVoiceEligible)

function useIsLocalPlayerPartyVoiceEligible()
	local v = useSelector(function(p)
		if p and p.LocalUserId then
			return tonumber(p.LocalUserId) or 0
		end

		return 0
	end)
	local v2 = v == 0
	return useIsUserPartyVoiceEligible(v), v2
end

return useIsLocalPlayerPartyVoiceEligible
