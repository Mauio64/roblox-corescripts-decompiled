local Parent = script:FindFirstAncestor("RoduxSquads").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

local function useCurrentSquadSelector() -- line: 5
	-- upvalues: useSelector (copy)
	return (useSelector(function(p1) -- line: 6
		return p1.Squad and (p1.Squad.Squad and p1.Squad.Squad.currentSquad)
	end))
end

return useCurrentSquadSelector
