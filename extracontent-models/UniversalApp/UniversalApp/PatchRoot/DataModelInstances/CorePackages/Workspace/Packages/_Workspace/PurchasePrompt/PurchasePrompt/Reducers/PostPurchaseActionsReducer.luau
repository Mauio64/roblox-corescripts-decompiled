local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux

require(PurchasePrompt.types)

local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)

return (Rodux.createReducer({}, {
	[SetPostPurchaseActions.name] = function(_, p2) -- line: 14
		return p2.postPurchaseActions
	end
}))
