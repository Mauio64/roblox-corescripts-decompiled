local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")

local SetCartPricingResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetCartPricingResponse")
local SetCartPricingFetching = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetCartPricingFetching")
local SetCartPricingFetchFailed = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetCartPricingFetchFailed")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")

local RequestAssetPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestAssetPurchase")
local RequestBundlePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestBundlePurchase")
local RequestGamepassPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestGamepassPurchase")
local RequestProductPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestProductPurchase")
local RequestSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestSubscriptionPurchase")
local RequestAvatarCreationFeePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestAvatarCreationFeePurchase")
local RequestExperiencePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestExperiencePurchase")
local RequestLookPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestLookPurchase")
local RequestRobuxUpsellPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestRobuxUpsellPurchase")
local RequestDeveloperSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestDeveloperSubscriptionPurchase")

local v5 = { response = nil, isFetching = false, requestId = nil }

local function clear()
	return v5
end

return (rodux.createReducer(v5, {
	[SetCartPricingFetching.name] = function(p2, p3)
		return { response = p2.response, isFetching = true, requestId = p3.requestId }
	end,
	[SetCartPricingResponse.name] = function(p2, p3)
		return { response = p3.response, isFetching = false, requestId = p2.requestId }
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
