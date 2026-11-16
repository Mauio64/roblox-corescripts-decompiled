local useCurrentSquadMember = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadMember")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoduxSquads")

local GetFFlagEnablePartyVoiceOnlyForEligibleUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Flags/GetFFlagEnablePartyVoiceOnlyForEligibleUsers")
local GetFStringPartyVoiceEligibilityAllowList = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Flags/GetFStringPartyVoiceEligibilityAllowList")

function LUAUFORGE_MODULE_GLOBALS_btt_getIsUserWhitelisted(p2): boolean
	for k in GetFStringPartyVoiceEligibilityAllowList():gmatch("%d+") do
		if tonumber(k) == p2 then
			return true
		end
	end

	return false
end

function LUAUFORGE_MODULE_GLOBALS_btt_useIsUserPartyVoiceEligible(p2)
	local v5 = useCurrentSquadMember(p2)

	local v6 = React.useMemo(function()
		return v5 and v5.partyVoiceEligible == true
	end, { v5 })

	local v7 = React.useMemo(function()
		return LUAUFORGE_MODULE_GLOBALS_btt_getIsUserWhitelisted(p2)
	end, { p2 })

	return v6 or v7
end

if GetFFlagEnablePartyVoiceOnlyForEligibleUsers() then
	return LUAUFORGE_MODULE_GLOBALS_btt_useIsUserPartyVoiceEligible
end

return function(p2): boolean
	return true
end
