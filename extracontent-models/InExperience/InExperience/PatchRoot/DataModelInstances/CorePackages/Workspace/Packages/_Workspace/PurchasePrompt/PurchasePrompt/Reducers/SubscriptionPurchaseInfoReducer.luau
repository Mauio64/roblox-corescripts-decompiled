local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local SubscriptionPurchaseInfoReceived = require(PurchasePrompt.Actions.SubscriptionPurchaseInfoReceived)
local getPreviewImageUrl = require(PurchasePrompt.getPreviewImageUrl)

return (Rodux.createReducer({}, {
	[SubscriptionPurchaseInfoReceived.name] = function(_, p2) -- line: 12
		-- upvalues: getPreviewImageUrl (copy)
		p2.subscriptionPurchaseInfo.ImageUrl = getPreviewImageUrl(p2.subscriptionPurchaseInfo)

		return p2.subscriptionPurchaseInfo
	end,
	[CompleteRequest.name] = function(_, _) -- line: 16
		return {}
	end
}))
