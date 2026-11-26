local HttpService = game:GetService("HttpService")
local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")

local rodux = PurchasePromptDeps.Rodux

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
local RequestVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestVIPServerPurchase")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")
local RefreshExpectedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RefreshExpectedPrice")
local VIPServerCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/VIPServerCreated")
local VIPServerRenamed = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/VIPServerRenamed")
local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local fFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local FFlagStableIdempotencyKeyForProductAndGamePass = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagStableIdempotencyKeyForProductAndGamePass")

local v5 = { requestType = RequestType.None }

return (rodux.createReducer(v5, {
	[RequestAssetPurchase.name] = function(p2, data)
		local v7 = data.idempotencyKey

		if v7 == nil or v7 == "" then
			v7 = HttpService:GenerateGUID(false)
		end

		return {
			id = data.id,
			infoType = Enum.InfoType.Asset,
			requestType = RequestType.Asset,
			equipIfPurchased = data.equipIfPurchased,
			isRobloxPurchase = data.isRobloxPurchase,
			idempotencyKey = v7,
			purchaseAuthToken = data.purchaseAuthToken or "",
			collectibleItemId = data.collectibleItemId or "",
			collectibleItemInstanceId = data.collectibleItemInstanceId or "",
			collectibleProductId = data.collectibleProductId or "",
			expectedPrice = data.expectedPrice or 0
		}
	end,
	[RequestGamepassPurchase.name] = function(p2, p3)
		local v7 = {
			id = p3.id,
			infoType = Enum.InfoType.GamePass,
			requestType = RequestType.GamePass,
			isRobloxPurchase = false
		}

		if not FFlagStableIdempotencyKeyForProductAndGamePass then
			return v7
		end

		local v8 = p3.idempotencyKey

		if v8 == nil or v8 == "" then
			v8 = HttpService:GenerateGUID(false)
		end

		v7.idempotencyKey = v8

		return v7
	end,
	[RequestProductPurchase.name] = function(p2, p3)
		local v7 = {
			id = p3.id,
			infoType = Enum.InfoType.Product,
			requestType = RequestType.Product,
			isRobloxPurchase = false
		}

		if not FFlagStableIdempotencyKeyForProductAndGamePass then
			return v7
		end

		local v8 = p3.idempotencyKey

		if v8 == nil or v8 == "" then
			v8 = HttpService:GenerateGUID(false)
		end

		v7.idempotencyKey = v8

		return v7
	end,
	[RequestBundlePurchase.name] = function(p2, data)
		local v7 = data.idempotencyKey

		if v7 == nil or v7 == "" then
			v7 = HttpService:GenerateGUID(false)
		end

		return {
			id = data.id,
			infoType = Enum.InfoType.Bundle,
			requestType = RequestType.Bundle,
			isRobloxPurchase = true,
			idempotencyKey = v7,
			purchaseAuthToken = data.purchaseAuthToken or "",
			collectibleItemId = data.collectibleItemId or "",
			collectibleItemInstanceId = data.collectibleItemInstanceId or "",
			collectibleProductId = data.collectibleProductId or "",
			expectedPrice = data.expectedPrice or 0
		}
	end,
	[RequestSubscriptionPurchase.name] = function(p2, p3)
		return { id = p3.id, requestType = RequestType.Subscription }
	end,
	[RequestAvatarCreationFeePurchase.name] = function(p2, p3)
		return {
			requestType = RequestType.AvatarCreationFee,
			humanoidModel = p3.humanoidModel,
			id = p3.guid
		}
	end,
	[RequestExperiencePurchase.name] = function(p2, p3)
		return { requestType = RequestType.Experience, universeId = p3.universeId }
	end,
	[RequestLookPurchase.name] = function(p2, p3)
		return { requestType = RequestType.Look, lookId = p3.lookId }
	end,
	[RequestRobuxUpsellPurchase.name] = fFlagAXMISWithBlackbird and function(p2, p3)
		return { requestType = RequestType.RobuxUpsell }
	end or nil,
	[RequestDeveloperSubscriptionPurchase.name] = function(p2, p3)
		return {
			requestType = RequestType.DeveloperSubscription,
			subscriptionId = p3.subscriptionId,
			expectedPrice = p3.expectedPrice
		}
	end,
	[RequestVIPServerPurchase.name] = function(p2, p3)
		local v7 = { requestType = RequestType.VIPServer }

		if fFlagLuaAppsEnablePromptVIPServerPurchase then
			v7.idempotencyKey = HttpService:GenerateGUID(false)
		end

		return v7
	end,
	[RefreshExpectedPrice.name] = function(p2, p3)
		local clone = table.clone(p2)
		clone.expectedPrice = p3.expectedPrice
		return clone
	end,
	[VIPServerCreated.name] = fFlagLuaAppsEnablePromptVIPServerPurchase and function(p2, data)
		local clone = table.clone(p2)
		clone.vipServerId = data.vipServerId
		clone.vipServerName = data.vipServerName
		clone.vipServerAccessCode = data.vipServerAccessCode
		return clone
	end or nil,
	[VIPServerRenamed.name] = fFlagLuaAppsEnablePromptVIPServerPurchase and function(p2, p3)
		local clone = table.clone(p2)
		clone.vipServerName = p3.vipServerName
		return clone
	end or nil,
	[CompleteRequest.name] = function(p2, p3)
		return v5
	end
}))
