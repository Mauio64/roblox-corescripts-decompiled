local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

require(PurchasePrompt.types)

local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)

return (Rodux.createReducer({}, {
	[SetPostPurchaseActions.name] = function(_, p)
		return p.postPurchaseActions
	end
}))
