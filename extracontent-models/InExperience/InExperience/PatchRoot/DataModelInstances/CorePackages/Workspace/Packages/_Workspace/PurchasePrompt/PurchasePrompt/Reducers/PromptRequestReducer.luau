local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local HttpService = game:GetService("HttpService")
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local SharedFlags = require(parent.SharedFlags)

local Rodux = PurchasePromptDeps.Rodux

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
local RequestVIPServerPurchase = require(PurchasePrompt.Actions.RequestVIPServerPurchase)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local RefreshExpectedPrice = require(PurchasePrompt.Actions.RefreshExpectedPrice)
local VIPServerCreated = require(PurchasePrompt.Actions.VIPServerCreated)
local VIPServerRenamed = require(PurchasePrompt.Actions.VIPServerRenamed)
local RequestType = require(PurchasePrompt.Enums.RequestType)

local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local FFlagStableIdempotencyKeyForProductAndGamePass = require(PurchasePrompt.Flags.FFlagStableIdempotencyKeyForProductAndGamePass)

local v = { requestType = RequestType.None }

return (Rodux.createReducer(v, {
	[RequestAssetPurchase.name] = function(_, data)
		local idempotencyKey = data.idempotencyKey

		if idempotencyKey == nil or idempotencyKey == "" then
			idempotencyKey = HttpService:GenerateGUID(false)
		end

		return {
			id = data.id,
			infoType = Enum.InfoType.Asset,
			requestType = RequestType.Asset,
			equipIfPurchased = data.equipIfPurchased,
			isRobloxPurchase = data.isRobloxPurchase,
			idempotencyKey = idempotencyKey,
			purchaseAuthToken = data.purchaseAuthToken or "",
			collectibleItemId = data.collectibleItemId or "",
			collectibleItemInstanceId = data.collectibleItemInstanceId or "",
			collectibleProductId = data.collectibleProductId or "",
			expectedPrice = data.expectedPrice or 0
		}
	end,
	[RequestGamepassPurchase.name] = function(_, p)
		local v2 = {
			id = p.id,
			infoType = Enum.InfoType.GamePass,
			requestType = RequestType.GamePass,
			isRobloxPurchase = false
		}

		if not FFlagStableIdempotencyKeyForProductAndGamePass then
			return v2
		end

		local idempotencyKey = p.idempotencyKey

		if idempotencyKey == nil or idempotencyKey == "" then
			idempotencyKey = HttpService:GenerateGUID(false)
		end

		v2.idempotencyKey = idempotencyKey

		return v2
	end,
	[RequestProductPurchase.name] = function(_, p)
		local v2 = {
			id = p.id,
			infoType = Enum.InfoType.Product,
			requestType = RequestType.Product,
			isRobloxPurchase = false
		}

		if not FFlagStableIdempotencyKeyForProductAndGamePass then
			return v2
		end

		local idempotencyKey = p.idempotencyKey

		if idempotencyKey == nil or idempotencyKey == "" then
			idempotencyKey = HttpService:GenerateGUID(false)
		end

		v2.idempotencyKey = idempotencyKey

		return v2
	end,
	[RequestBundlePurchase.name] = function(_, data)
		local idempotencyKey = data.idempotencyKey

		if idempotencyKey == nil or idempotencyKey == "" then
			idempotencyKey = HttpService:GenerateGUID(false)
		end

		return {
			id = data.id,
			infoType = Enum.InfoType.Bundle,
			requestType = RequestType.Bundle,
			isRobloxPurchase = true,
			idempotencyKey = idempotencyKey,
			purchaseAuthToken = data.purchaseAuthToken or "",
			collectibleItemId = data.collectibleItemId or "",
			collectibleItemInstanceId = data.collectibleItemInstanceId or "",
			collectibleProductId = data.collectibleProductId or "",
			expectedPrice = data.expectedPrice or 0
		}
	end,
	[RequestSubscriptionPurchase.name] = function(_, p)
		return { id = p.id, requestType = RequestType.Subscription }
	end,
	[RequestAvatarCreationFeePurchase.name] = function(_, p)
		return {
			requestType = RequestType.AvatarCreationFee,
			humanoidModel = p.humanoidModel,
			id = p.guid
		}
	end,
	[RequestExperiencePurchase.name] = function(_, p)
		return { requestType = RequestType.Experience, universeId = p.universeId }
	end,
	[RequestLookPurchase.name] = function(_, p)
		return { requestType = RequestType.Look, lookId = p.lookId }
	end,
	[RequestRobuxUpsellPurchase.name] = FFlagAXMISWithBlackbird and function(_, _)
		return { requestType = RequestType.RobuxUpsell }
	end or nil,
	[RequestDeveloperSubscriptionPurchase.name] = function(_, p)
		return {
			requestType = RequestType.DeveloperSubscription,
			subscriptionId = p.subscriptionId,
			expectedPrice = p.expectedPrice
		}
	end,
	[RequestVIPServerPurchase.name] = function(_, _)
		local v2 = { requestType = RequestType.VIPServer }

		if FFlagLuaAppsEnablePromptVIPServerPurchase then
			v2.idempotencyKey = HttpService:GenerateGUID(false)
		end

		return v2
	end,
	[RefreshExpectedPrice.name] = function(p, p2)
		local clone = table.clone(p)
		clone.expectedPrice = p2.expectedPrice
		return clone
	end,
	[VIPServerCreated.name] = FFlagLuaAppsEnablePromptVIPServerPurchase and function(p, data)
		local clone = table.clone(p)
		clone.vipServerId = data.vipServerId
		clone.vipServerName = data.vipServerName
		clone.vipServerAccessCode = data.vipServerAccessCode
		return clone
	end or nil,
	[VIPServerRenamed.name] = FFlagLuaAppsEnablePromptVIPServerPurchase and function(p, p2)
		local clone = table.clone(p)
		clone.vipServerName = p2.vipServerName
		return clone
	end or nil,
	[CompleteRequest.name] = function(_, _)
		return v
	end
}))
