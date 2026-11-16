local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

require(parent.IAPExperience)

local SetCartPricingResponse = require(PurchasePrompt.Actions.SetCartPricingResponse)
local SetCartPricingFetching = require(PurchasePrompt.Actions.SetCartPricingFetching)
local SetCartPricingFetchFailed = require(PurchasePrompt.Actions.SetCartPricingFetchFailed)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)

local RequestAssetPurchase = require(PurchasePrompt.Actions.RequestAssetPurchase)
local RequestBundlePurchase = require(PurchasePrompt.Actions.RequestBundlePurchase)
local RequestGamepassPurchase = require(PurchasePrompt.Actions.RequestGamepassPurchase)
local RequestProductPurchase = require(PurchasePrompt.Actions.RequestProductPurchase)
local RequestSubscriptionPurchase = require(PurchasePrompt.Actions.RequestSubscriptionPurchase)
local RequestAvatarCreationFeePurchase = require(PurchasePrompt.Actions.RequestAvatarCreationFeePurchase)
local RequestExperiencePurchase = require(PurchasePrompt.Actions.RequestExperiencePurchase)
local RequestLookPurchase = require(PurchasePrompt.Actions.RequestLookPurchase)
local RequestRobuxUpsellPurchase = require(PurchasePrompt.Actions.RequestRobuxUpsellPurchase)
local RequestDeveloperSubscriptionPurchase = require(PurchasePrompt.Actions.RequestDeveloperSubscriptionPurchase)

local v = { response = nil, isFetching = false, requestId = nil }

local function clear()
	return v
end

return (Rodux.createReducer(v, {
	[SetCartPricingFetching.name] = function(p, p2)
		return { response = p.response, isFetching = true, requestId = p2.requestId }
	end,
	[SetCartPricingResponse.name] = function(p, p2)
		return { response = p2.response, isFetching = false, requestId = p.requestId }
	end,
	[SetCartPricingFetchFailed.name] = clear,
	[CompleteRequest.name] = clear,
	[RequestAssetPurchase.name] = clear,
	[RequestBundlePurchase.name] = clear,
	[RequestGamepassPurchase.name] = clear,
	[RequestProductPurchase.name] = clear,
	[RequestSubscriptionPurchase.name] = clear,
	[RequestAvatarCreationFeePurchase.name] = clear,
	[RequestExperiencePurchase.name] = clear,
	[RequestLookPurchase.name] = clear,
	[RequestRobuxUpsellPurchase.name] = clear,
	[RequestDeveloperSubscriptionPurchase.name] = clear
}))
