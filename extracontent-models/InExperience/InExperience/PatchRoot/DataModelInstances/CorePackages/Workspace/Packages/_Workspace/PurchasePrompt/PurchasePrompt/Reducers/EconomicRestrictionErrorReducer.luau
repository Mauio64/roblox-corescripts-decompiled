local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetEconomicRestrictionError = require(PurchasePrompt.Actions.SetEconomicRestrictionError)

return Rodux.createReducer({}, {
	[SetEconomicRestrictionError.name] = function(_, p)
		return { timeoutMinutes = p.timeoutMinutes, violationType = p.violationType }
	end
})
