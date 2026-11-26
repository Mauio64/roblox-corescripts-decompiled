local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useSelector

local useIsUserPartyVoiceEligible = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useIsUserPartyVoiceEligible")

function LUAUFORGE_MODULE_GLOBALS_buY_useIsLocalPlayerPartyVoiceEligible()
	local v5 = useSelector(function(p2)
		if p2 and p2.LocalUserId then
			return tonumber(p2.LocalUserId) or 0
		end

		return 0
	end)
	local v6 = v5 == 0
	return useIsUserPartyVoiceEligible(v5), v6
end

return LUAUFORGE_MODULE_GLOBALS_buY_useIsLocalPlayerPartyVoiceEligible
