local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useSelector

function LUAUFORGE_MODULE_GLOBALS_bsY_useCurrentSquadId()
	return (useSelector((React.useCallback(function(p2)
		if
			p2.Squad
			and p2.Squad.Squad
			and p2.Squad.Squad.currentSquad
			and p2.Squad.Squad.currentSquad.squadId ~= ""
		then
			return p2.Squad.Squad.currentSquad.squadId
		end

		return nil
	end, {}))))
end

return LUAUFORGE_MODULE_GLOBALS_bsY_useCurrentSquadId
