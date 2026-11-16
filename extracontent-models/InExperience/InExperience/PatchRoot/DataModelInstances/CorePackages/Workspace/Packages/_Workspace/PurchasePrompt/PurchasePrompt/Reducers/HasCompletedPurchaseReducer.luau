local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local PurchaseCompleteRecieved = require(PurchasePrompt.Actions.PurchaseCompleteRecieved)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)

return Rodux.createReducer(false, {
	[PurchaseCompleteRecieved.name] = function(_, _): boolean
		return true
	end,
	[CompleteRequest.name] = function(_, _): boolean
		return false
	end
})
