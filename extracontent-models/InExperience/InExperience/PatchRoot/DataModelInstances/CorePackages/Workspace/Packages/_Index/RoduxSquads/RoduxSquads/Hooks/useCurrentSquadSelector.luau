local parent = script:FindFirstAncestor("RoduxSquads").Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useCurrentSquadSelector()
	return (useSelector(function(p)
		return p.Squad and p.Squad.Squad and p.Squad.Squad.currentSquad
	end))
end

return useCurrentSquadSelector
