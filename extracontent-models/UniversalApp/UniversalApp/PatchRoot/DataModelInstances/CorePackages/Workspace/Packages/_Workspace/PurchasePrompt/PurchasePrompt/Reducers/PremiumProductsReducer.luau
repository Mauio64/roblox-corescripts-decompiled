local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local PremiumInfoRecieved = require(PurchasePrompt.Actions.PremiumInfoRecieved)

return (Rodux.createReducer({}, {
	[PremiumInfoRecieved.name] = function(_, p2) -- line: 11
		return p2.premiumInfo
	end,
	[CompleteRequest.name] = function(_, _) -- line: 14
		return {}
	end
}))
