local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetProductPayload = require(PurchasePrompt.Actions.SetProductPayload)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags.FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagPromptPurchaseClearStateOnCompletion = require(PurchasePrompt.Flags.FFlagPromptPurchaseClearStateOnCompletion)

local v = {}

return (Rodux.createReducer(v, {
	[SetProductPayload.name] = function(_, p)
		return p.productPayload
	end,
	[CompleteRequest.name] = function(p, _)
		if
			FFlagEnableUnifiedPurchaseFlowForDevSubs and p.kind == "DeveloperSubscription"
			or FFlagPromptPurchaseClearStateOnCompletion
		then
			return v
		end

		return p
	end
}))
