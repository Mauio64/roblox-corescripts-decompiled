local Players = game:GetService("Players")
local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local GetFFlagEnablePartyVoiceOnlyForEligibleUsers = require(SquadsParent.SquadsCore.Flags).GetFFlagEnablePartyVoiceOnlyForEligibleUsers
local GetFStringPartyVoiceEligibilityAllowList = require(SquadsParent.SquadsCore.Flags).GetFStringPartyVoiceEligibilityAllowList

function getIsUserWhitelisted(n1: number) -- line: 18
	-- upvalues: GetFStringPartyVoiceEligibilityAllowList (copy)
	for match in GetFStringPartyVoiceEligibilityAllowList():gmatch("%d+") do
		if n1 == tonumber(match) then
			return true
		end
	end

	return false
end
function useIsAnyOtherUserPartyVoiceEligible() -- line: 27
	-- upvalues: Players (copy), useCurrentSquadSelector (copy), React (copy)
	local v11 = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
	local v12 = useCurrentSquadSelector()
	local v13 = React.useMemo(function() -- line: 30
		-- upvalues: v12 (copy)
		if v12 then
			return v12.members
		end

		return {}
	end, { v12 })

	return React.useMemo(function() -- line: 37
		-- upvalues: v11 (copy), v13 (copy)
		if v11 ~= 0 then
			for _, v in ipairs(v13) do
				if v.userId ~= v11 and (v.partyVoiceEligible or getIsUserWhitelisted(v.userId)) then
					return true
				end
			end
		end

		return false
	end, {
		v11,
		v13
	})
end

if not GetFFlagEnablePartyVoiceOnlyForEligibleUsers() then
	return function() -- line: 55
		return true
	end
end

return useIsAnyOtherUserPartyVoiceEligible
