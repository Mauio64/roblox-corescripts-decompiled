local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local PurchaseCompleteRecieved = require(PurchasePrompt.Actions.PurchaseCompleteRecieved)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)

return Rodux.createReducer(false, {
	[PurchaseCompleteRecieved.name] = function(_, _) -- line: 10
		return true
	end,
	[CompleteRequest.name] = function(_, _) -- line: 13
		return false
	end
})
