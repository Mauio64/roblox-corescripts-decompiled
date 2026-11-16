local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local useCurrentSquadMember = require(script.Parent.useCurrentSquadMember)

local React = require(parent.React)
require(parent.RoduxSquads)

local GetFFlagEnablePartyVoiceOnlyForEligibleUsers = require(SquadsCore.Flags.GetFFlagEnablePartyVoiceOnlyForEligibleUsers)
local GetFStringPartyVoiceEligibilityAllowList = require(SquadsCore.Flags.GetFStringPartyVoiceEligibilityAllowList)

function getIsUserWhitelisted(p: number): boolean
	for k in GetFStringPartyVoiceEligibilityAllowList():gmatch("%d+") do
		if tonumber(k) == p then
			return true
		end
	end

	return false
end

function useIsUserPartyVoiceEligible(p: number)
	local v = useCurrentSquadMember(p)

	local v2 = React.useMemo(function()
		return v and v.partyVoiceEligible == true
	end, { v })

	local v3 = React.useMemo(function()
		return getIsUserWhitelisted(p)
	end, { p })

	return v2 or v3
end

if GetFFlagEnablePartyVoiceOnlyForEligibleUsers() then
	return useIsUserPartyVoiceEligible
end

return function(_: number): boolean
	return true
end
