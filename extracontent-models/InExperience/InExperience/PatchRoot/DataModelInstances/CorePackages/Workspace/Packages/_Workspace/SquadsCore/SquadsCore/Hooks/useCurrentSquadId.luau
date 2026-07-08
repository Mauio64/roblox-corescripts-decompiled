local Parent = script:FindFirstAncestor("SquadsCore").Parent
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

function useCurrentSquadId() -- line: 7
	-- upvalues: React (copy), useSelector (copy)
	local v4 = React.useCallback(function(p1) -- line: 8
		if p1.Squad and (p1.Squad.Squad and p1.Squad.Squad.currentSquad and p1.Squad.Squad.currentSquad.squadId ~= "") then
			return p1.Squad.Squad.currentSquad.squadId
		end

		return nil
	end, {})

	return (useSelector(v4))
end

return useCurrentSquadId
