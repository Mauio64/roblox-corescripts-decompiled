local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetEconomicRestrictionError = require(PurchasePrompt.Actions.SetEconomicRestrictionError)

return Rodux.createReducer({}, {
	[SetEconomicRestrictionError.name] = function(_, p2) -- line: 10
		return {
			timeoutMinutes = p2.timeoutMinutes,
			violationType = p2.violationType
		}
	end
})
