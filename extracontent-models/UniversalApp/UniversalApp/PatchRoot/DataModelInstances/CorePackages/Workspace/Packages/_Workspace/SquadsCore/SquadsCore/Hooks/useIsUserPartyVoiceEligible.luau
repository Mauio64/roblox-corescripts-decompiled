local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local useCurrentSquadMember = require(script.Parent.useCurrentSquadMember)
local React = require(SquadsCoreParent.React)

require(SquadsCoreParent.RoduxSquads)

local GetFFlagEnablePartyVoiceOnlyForEligibleUsers = require(SquadsCore.Flags.GetFFlagEnablePartyVoiceOnlyForEligibleUsers)
local GetFStringPartyVoiceEligibilityAllowList = require(SquadsCore.Flags.GetFStringPartyVoiceEligibilityAllowList)

function getIsUserWhitelisted(n1: number) -- line: 15
	-- upvalues: GetFStringPartyVoiceEligibilityAllowList (copy)
	for match in GetFStringPartyVoiceEligibilityAllowList():gmatch("%d+") do
		if n1 == tonumber(match) then
			return true
		end
	end

	return false
end
function useIsUserPartyVoiceEligible(n2: number) -- line: 24
	-- upvalues: useCurrentSquadMember (copy), React (copy)
	local v10 = useCurrentSquadMember(n2)
	local v11 = React.useMemo(function() -- line: 27
		-- upvalues: v10 (copy)
		return v10 and v10.partyVoiceEligible == true
	end, { v10 })
	local v12 = React.useMemo(function() -- line: 31
		-- upvalues: n2 (copy)
		return getIsUserWhitelisted(n2)
	end, { n2 })

	return v11 or v12
end

if not GetFFlagEnablePartyVoiceOnlyForEligibleUsers() then
	return function(_: number) -- line: 40
		return true
	end
end

return useIsUserPartyVoiceEligible
