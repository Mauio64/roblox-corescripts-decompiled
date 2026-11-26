local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createProfileInsightsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ProfileInsights/createProfileInsightsStore")

local computed = Signals.createComputed(function()
	return createProfileInsightsStore()
end)

return {
	get = function()
		return computed(false)
	end
}
