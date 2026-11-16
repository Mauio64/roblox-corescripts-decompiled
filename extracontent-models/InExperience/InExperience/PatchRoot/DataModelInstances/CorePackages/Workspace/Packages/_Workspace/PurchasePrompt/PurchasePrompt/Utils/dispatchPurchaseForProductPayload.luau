local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local SharedFlags = require(parent.SharedFlags)

local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum
local initiatePurchase = require(PurchasePrompt.Thunks.initiatePurchase)
local initiateBundlePurchase = require(PurchasePrompt.Thunks.initiateBundlePurchase)

local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require(PurchasePrompt.Flags.FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell)
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local function dispatchPurchaseForProductPayload(callback, data, _, flag: boolean)
	if data.kind == productTypeEnum.Asset then
		callback(initiatePurchase(
			data.id,
			Enum.InfoType.Asset,
			data.equipIfPurchased,
			data.isRobloxPurchase,
			data.idempotencyKey,
			nil,
			data.collectibleItemId,
			data.collectibleItemInstanceId,
			data.collectibleProductId,
			data.expectedPrice,
			nil,
			flag
		))
	elseif data.kind == productTypeEnum.Gamepass then
		callback(initiatePurchase(data.id, Enum.InfoType.GamePass, nil, nil, nil, nil, nil, nil, nil, nil, nil, flag))
	elseif data.kind == productTypeEnum.Product then
		callback(initiatePurchase(
			data.id,
			Enum.InfoType.Product,
			data.equipIfPurchased,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			flag
		))
	elseif data.kind == productTypeEnum.Bundle then
		callback(initiateBundlePurchase(
			data.id,
			data.idempotencyKey,
			nil,
			data.collectibleItemId,
			data.collectibleItemInstanceId,
			data.collectibleProductId,
			data.expectedPrice,
			flag
		))
	elseif data.kind == productTypeEnum.Experience then
		callback(initiatePurchase(
			data.universeId,
			productTypeEnum.Experience,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			{ name = data.experienceName, imageUrl = data.experienceIconUrl },
			flag
		))
	elseif data.kind == productTypeEnum.Look then
		local id = data.id
		local look = productTypeEnum.Look
		local v

		if FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then
			v = {
				excludedAssetIds = data.excludedAssetIds,
				excludedBundleIds = data.excludedBundleIds,
				timedOptions = data.timedOptions
			}
		else
			v = { expectedPrice = data.expectedPrice }
		end

		callback(initiatePurchase(id, look, nil, nil, nil, nil, nil, nil, nil, nil, v, flag))
	elseif FFlagAXMISWithBlackbird and data.kind == productTypeEnum.RobuxUpsell then
		callback(initiatePurchase(
			data.id,
			productTypeEnum.RobuxUpsell,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			false
		))
	elseif data.kind == productTypeEnum.DeveloperSubscription then
		callback(initiatePurchase(
			data.subscriptionId,
			productTypeEnum.DeveloperSubscription,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			data.expectedPrice,
			{
				expectedPrice = data.expectedPrice,
				name = data.name,
				iconImageAssetId = data.iconImageAssetId,
				displayPrice = data.displayPrice
			},
			flag
		))
	elseif FFlagLuaAppsEnablePromptVIPServerPurchase and data.kind == productTypeEnum.VIPServer then
		callback(initiatePurchase(
			data.universeId,
			productTypeEnum.VIPServer,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			flag
		))
	end
end

return dispatchPurchaseForProductPayload
