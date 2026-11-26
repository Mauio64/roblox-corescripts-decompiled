local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createCreatorAnalyticsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/createCreatorAnalyticsStore")

return Signals.createComputed(function()
	return createCreatorAnalyticsStore()
end)
