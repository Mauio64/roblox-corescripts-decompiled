local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/RoactUtils").Hooks.RoactRodux.useSelector

local function useCurrentSquadSelector()
	return (useSelector(function(p2)
		return p2.Squad and p2.Squad.Squad and p2.Squad.Squad.currentSquad
	end))
end

return useCurrentSquadSelector
