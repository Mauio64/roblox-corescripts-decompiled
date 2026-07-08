local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local HttpService = game:GetService("HttpService")
local PurchasePromptDeps = require(PurchasePromptParent.PurchasePromptDeps)
local SharedFlags = require(PurchasePromptParent.SharedFlags)
local Rodux = PurchasePromptDeps.Rodux
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
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local RefreshExpectedPrice = require(PurchasePrompt.Actions.RefreshExpectedPrice)
local RequestType = require(PurchasePrompt.Enums.RequestType)
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local t1 = {
	requestType = RequestType.None
}

return (Rodux.createReducer(t1, {
	[RequestAssetPurchase.name] = function(_, p2) -- line: 30
		-- upvalues: HttpService (copy), RequestType (copy)
		local idempotencyKey = p2.idempotencyKey

		if idempotencyKey == nil or idempotencyKey == "" then
			idempotencyKey = HttpService:GenerateGUID(false)
		end

		return {
			id = p2.id,
			infoType = Enum.InfoType.Asset,
			requestType = RequestType.Asset,
			equipIfPurchased = p2.equipIfPurchased,
			isRobloxPurchase = p2.isRobloxPurchase,
			idempotencyKey = idempotencyKey,
			purchaseAuthToken = p2.purchaseAuthToken or "",
			collectibleItemId = p2.collectibleItemId or "",
			collectibleItemInstanceId = p2.collectibleItemInstanceId or "",
			collectibleProductId = p2.collectibleProductId or "",
			expectedPrice = p2.expectedPrice or 0
		}
	end,
	[RequestGamepassPurchase.name] = function(_, p4) -- line: 49
		-- upvalues: RequestType (copy)
		return {
			isRobloxPurchase = false,
			id = p4.id,
			infoType = Enum.InfoType.GamePass,
			requestType = RequestType.GamePass
		}
	end,
	[RequestProductPurchase.name] = function(_, p6) -- line: 57
		-- upvalues: RequestType (copy)
		return {
			isRobloxPurchase = false,
			id = p6.id,
			infoType = Enum.InfoType.Product,
			requestType = RequestType.Product
		}
	end,
	[RequestBundlePurchase.name] = function(_, p8) -- line: 65
		-- upvalues: HttpService (copy), RequestType (copy)
		local idempotencyKey = p8.idempotencyKey

		if idempotencyKey == nil or idempotencyKey == "" then
			idempotencyKey = HttpService:GenerateGUID(false)
		end

		return {
			isRobloxPurchase = true,
			id = p8.id,
			infoType = Enum.InfoType.Bundle,
			requestType = RequestType.Bundle,
			idempotencyKey = idempotencyKey,
			purchaseAuthToken = p8.purchaseAuthToken or "",
			collectibleItemId = p8.collectibleItemId or "",
			collectibleItemInstanceId = p8.collectibleItemInstanceId or "",
			collectibleProductId = p8.collectibleProductId or "",
			expectedPrice = p8.expectedPrice or 0
		}
	end,
	[RequestPremiumPurchase.name] = function(_, _) -- line: 83
		-- upvalues: RequestType (copy)
		return {
			requestType = RequestType.Premium
		}
	end,
	[RequestSubscriptionPurchase.name] = function(_, p12) -- line: 88
		-- upvalues: RequestType (copy)
		return {
			id = p12.id,
			requestType = RequestType.Subscription
		}
	end,
	[RequestAvatarCreationFeePurchase.name] = function(_, p14) -- line: 94
		-- upvalues: RequestType (copy)
		return {
			requestType = RequestType.AvatarCreationFee,
			humanoidModel = p14.humanoidModel,
			id = p14.guid
		}
	end,
	[RequestExperiencePurchase.name] = function(_, p16) -- line: 101
		-- upvalues: RequestType (copy)
		return {
			requestType = RequestType.Experience,
			universeId = p16.universeId
		}
	end,
	[RequestLookPurchase.name] = function(_, p18) -- line: 107
		-- upvalues: RequestType (copy)
		return {
			requestType = RequestType.Look,
			lookId = p18.lookId
		}
	end,
	[RequestRobuxUpsellPurchase.name] = if not FFlagAXMISWithBlackbird then nil else function(_, _) -- line: 114
		-- upvalues: RequestType (copy)
		return {
			requestType = RequestType.RobuxUpsell
		}
	end,
	[RequestDeveloperSubscriptionPurchase.name] = function(_, p22) -- line: 120
		-- upvalues: RequestType (copy)
		return {
			requestType = RequestType.DeveloperSubscription,
			subscriptionId = p22.subscriptionId,
			expectedPrice = p22.expectedPrice
		}
	end,
	[RefreshExpectedPrice.name] = function(p23, p24) -- line: 127
		local v49 = table.clone(p23)

		v49.expectedPrice = p24.expectedPrice

		return v49
	end,
	[CompleteRequest.name] = function(_, _) -- line: 132
		-- upvalues: t1 (copy)
		return t1
	end
}))
