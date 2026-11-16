local parent = script:FindFirstAncestor("SquadsCore").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

function useCurrentSquadMembers()
	return (useSelector((React.useCallback(function(p)
		if p.Squad and p.Squad.Squad and p.Squad.Squad.currentSquad and p.Squad.Squad.currentSquad.members then
			return p.Squad.Squad.currentSquad.members
		end

		return nil
	end, {}))))
end

return useCurrentSquadMembers
