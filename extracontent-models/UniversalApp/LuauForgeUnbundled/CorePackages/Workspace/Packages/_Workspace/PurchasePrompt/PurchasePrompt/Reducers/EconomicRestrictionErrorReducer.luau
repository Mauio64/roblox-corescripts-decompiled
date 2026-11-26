local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetEconomicRestrictionError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetEconomicRestrictionError")

return rodux.createReducer({}, {
	[SetEconomicRestrictionError.name] = function(p2, p3)
		return { timeoutMinutes = p3.timeoutMinutes, violationType = p3.violationType }
	end
})
