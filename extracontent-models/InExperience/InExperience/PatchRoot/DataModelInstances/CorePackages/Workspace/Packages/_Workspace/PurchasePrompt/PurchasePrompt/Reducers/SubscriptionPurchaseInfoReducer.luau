local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local SubscriptionPurchaseInfoReceived = require(PurchasePrompt.Actions.SubscriptionPurchaseInfoReceived)
local getPreviewImageUrl = require(PurchasePrompt.getPreviewImageUrl)

return (Rodux.createReducer({}, {
	[SubscriptionPurchaseInfoReceived.name] = function(_, p)
		p.subscriptionPurchaseInfo.ImageUrl = getPreviewImageUrl(p.subscriptionPurchaseInfo)
		return p.subscriptionPurchaseInfo
	end,
	[CompleteRequest.name] = function(_, _)
		return {}
	end
}))
