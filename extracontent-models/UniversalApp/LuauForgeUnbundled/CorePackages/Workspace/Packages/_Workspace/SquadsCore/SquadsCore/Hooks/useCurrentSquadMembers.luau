local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useSelector

function LUAUFORGE_MODULE_GLOBALS_btb_useCurrentSquadMembers()
	return (useSelector((React.useCallback(function(p2)
		if
			p2.Squad
			and p2.Squad.Squad
			and p2.Squad.Squad.currentSquad
			and p2.Squad.Squad.currentSquad.members
		then
			return p2.Squad.Squad.currentSquad.members
		end

		return nil
	end, {}))))
end

return LUAUFORGE_MODULE_GLOBALS_btb_useCurrentSquadMembers
