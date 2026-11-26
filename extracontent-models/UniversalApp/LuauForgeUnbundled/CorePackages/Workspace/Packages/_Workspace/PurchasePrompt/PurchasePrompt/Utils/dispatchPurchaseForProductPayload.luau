local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")

local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum
local initiatePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/initiatePurchase")
local initiateBundlePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/initiateBundlePurchase")

local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell")
local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local fFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local function dispatchPurchaseForProductPayload(callback, data, p2, p3)
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
			p3
		))
	elseif data.kind == productTypeEnum.Gamepass then
		callback(initiatePurchase(data.id, Enum.InfoType.GamePass, nil, nil, nil, nil, nil, nil, nil, nil, nil, p3))
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
			p3
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
			p3
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
			p3
		))
	elseif data.kind == productTypeEnum.Look then
		local id = data.id
		local look = productTypeEnum.Look

		local v14 = if FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then {
			excludedAssetIds = data.excludedAssetIds,
			excludedBundleIds = data.excludedBundleIds,
			timedOptions = data.timedOptions
		} else { expectedPrice = data.expectedPrice }
		callback(initiatePurchase(id, look, nil, nil, nil, nil, nil, nil, nil, nil, v14, p3))
	elseif fFlagAXMISWithBlackbird and data.kind == productTypeEnum.RobuxUpsell then
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
			p3
		))
	elseif fFlagLuaAppsEnablePromptVIPServerPurchase and data.kind == productTypeEnum.VIPServer then
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
			p3
		))
	end
end

return dispatchPurchaseForProductPayload
