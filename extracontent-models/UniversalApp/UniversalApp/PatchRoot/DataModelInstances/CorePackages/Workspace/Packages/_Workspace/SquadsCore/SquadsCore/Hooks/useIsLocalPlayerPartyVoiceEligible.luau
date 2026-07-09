local Parent = script:FindFirstAncestor("SquadsCore").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useIsUserPartyVoiceEligible = require(script.Parent.useIsUserPartyVoiceEligible)

function useIsLocalPlayerPartyVoiceEligible() -- line: 9
	-- upvalues: useSelector (copy), useIsUserPartyVoiceEligible (copy)
	local v4 = useSelector(function(p1) -- line: 10
		if p1 and p1.LocalUserId then
			return tonumber(p1.LocalUserId) or 0
		end

		return 0
	end)
	local v5 = v4 == 0 and true

	return useIsUserPartyVoiceEligible(v4), v5
end

return useIsLocalPlayerPartyVoiceEligible
