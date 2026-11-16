local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createGoalMilestonesStore = require(script.Parent.createGoalMilestonesStore)

return Signals.createComputed(function()
	return createGoalMilestonesStore()
end)
