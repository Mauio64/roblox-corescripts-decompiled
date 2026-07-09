local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux

require(PurchasePromptParent.IAPExperience)

local SetCartPricingResponse = require(PurchasePrompt.Actions.SetCartPricingResponse)
local SetCartPricingFetching = require(PurchasePrompt.Actions.SetCartPricingFetching)
local SetCartPricingFetchFailed = require(PurchasePrompt.Actions.SetCartPricingFetchFailed)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local RequestAssetPurchase = require(PurchasePrompt.Actions.RequestAssetPurchase)
local RequestBundlePurchase = require(PurchasePrompt.Actions.RequestBundlePurchase)
local RequestGamepassPurchase = require(PurchasePrompt.Actions.RequestGamepassPurchase)
local RequestProductPurchase = require(PurchasePrompt.Actions.RequestProductPurchase)
local RequestPremiumPurchase = require(PurchasePrompt.Actions.RequestPremiumPurchase)
local RequestSubscriptionPurchase = require(PurchasePrompt.Actions.RequestSubscriptionPurchase)
local RequestAvatarCreationFeePurchase = require(PurchasePrompt.Actions.RequestAvatarCreationFeePurchase)
local RequestExperiencePurchase = require(PurchasePrompt.Actions.RequestExperiencePurchase)
local RequestLookPurchase = require(PurchasePrompt.Actions.RequestLookPurchase)
local RequestRobuxUpsellPurchase = require(PurchasePrompt.Actions.RequestRobuxUpsellPurchase)
local RequestDeveloperSubscriptionPurchase = require(PurchasePrompt.Actions.RequestDeveloperSubscriptionPurchase)
local t1 = {
	response = nil,
	isFetching = false,
	requestId = nil
}

local function clear() -- line: 52
	-- upvalues: t1 (copy)
	return t1
end

return (Rodux.createReducer(t1, {
	[SetCartPricingFetching.name] = function(t2: {[any]: any}, p1) -- line: 57
		return {
			isFetching = true,
			response = t2.response,
			requestId = p1.requestId
		}
	end,
	[SetCartPricingResponse.name] = function(t3: {[any]: any}, p2) -- line: 60
		return {
			isFetching = false,
			response = p2.response,
			requestId = t3.requestId
		}
	end,
	[SetCartPricingFetchFailed.name] = clear,
	[CompleteRequest.name] = clear,
	[RequestAssetPurchase.name] = clear,
	[RequestBundlePurchase.name] = clear,
	[RequestGamepassPurchase.name] = clear,
	[RequestProductPurchase.name] = clear,
	[RequestPremiumPurchase.name] = clear,
	[RequestSubscriptionPurchase.name] = clear,
	[RequestAvatarCreationFeePurchase.name] = clear,
	[RequestExperiencePurchase.name] = clear,
	[RequestLookPurchase.name] = clear,
	[RequestRobuxUpsellPurchase.name] = clear,
	[RequestDeveloperSubscriptionPurchase.name] = clear
}))
