local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetProduct = require(PurchasePrompt.Actions.SetProduct)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)

return (Rodux.createReducer({}, {
	[SetProduct.name] = function(_, p2) -- line: 11
		return {
			id = p2.id,
			infoType = p2.infoType,
			equipIfPurchased = p2.equipIfPurchased
		}
	end,
	[CompleteRequest.name] = function(_, _) -- line: 18
		return {}
	end
}))
