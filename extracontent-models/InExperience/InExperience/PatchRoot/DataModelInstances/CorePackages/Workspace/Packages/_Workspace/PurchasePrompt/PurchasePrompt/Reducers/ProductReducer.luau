local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetProduct = require(PurchasePrompt.Actions.SetProduct)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)

return (Rodux.createReducer({}, {
	[SetProduct.name] = function(_, data)
		return { id = data.id, infoType = data.infoType, equipIfPurchased = data.equipIfPurchased }
	end,
	[CompleteRequest.name] = function(_, _)
		return {}
	end
}))
