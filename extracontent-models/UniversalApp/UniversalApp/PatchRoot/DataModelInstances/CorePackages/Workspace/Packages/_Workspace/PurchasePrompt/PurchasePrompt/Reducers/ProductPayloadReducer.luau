local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetProductPayload = require(PurchasePrompt.Actions.SetProductPayload)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local t1 = {}

return (Rodux.createReducer(t1, {
	[SetProductPayload.name] = function(_, p2) -- line: 14
		return p2.productPayload
	end,
	[CompleteRequest.name] = function(p3, _) -- line: 17
		-- upvalues: FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), t1 (copy)
		if FFlagEnableUnifiedPurchaseFlowForDevSubs and p3.kind == "DeveloperSubscription" then
			return t1
		end

		return p3
	end
}))
