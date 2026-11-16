local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createGoalMilestonesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/createGoalMilestonesStore")

return Signals.createComputed(function()
	return createGoalMilestonesStore()
end)
