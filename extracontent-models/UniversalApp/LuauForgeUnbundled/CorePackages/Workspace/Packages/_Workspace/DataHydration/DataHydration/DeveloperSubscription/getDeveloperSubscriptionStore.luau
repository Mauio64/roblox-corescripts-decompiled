local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createDeveloperSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperSubscription/createDeveloperSubscriptionStore")

return Signals.createComputed(function()
	return createDeveloperSubscriptionStore()
end)
