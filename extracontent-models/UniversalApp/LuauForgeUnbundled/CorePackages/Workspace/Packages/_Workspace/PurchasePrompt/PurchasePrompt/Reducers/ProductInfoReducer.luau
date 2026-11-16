local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")
local ProductInfoReceived = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ProductInfoReceived")
local BundleProductInfoReceived = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/BundleProductInfoReceived")
local ItemType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/ItemType")
local getPreviewImageUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/getPreviewImageUrl")

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local fFlagUnifiedPurchaseOptimizeTTIMarketplace = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagUnifiedPurchaseOptimizeTTIMarketplace

local GetFFlagFixBundlePromptThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagFixBundlePromptThumbnail")
local GetFFlagEnableCreatorStorePurchasingCutover = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableCreatorStorePurchasingCutover")
local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum
local normalizePriceDiscountDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/normalizePriceDiscountDetails")

local fFlagPurchasePromptFetchCartPricingForLooks = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagPurchasePromptFetchCartPricingForLooks

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

return (rodux.createReducer({}, {
	[ProductInfoReceived.name] = function(p2, p3)
		local productInfo = p3.productInfo

		local v6 = ""
		local v7 = ""
		local v8

		if fFlagUnifiedPurchaseOptimizeTTIMarketplace then
			v8 = productInfo.ProductType == Constants.ProductType.Asset
				or productInfo.ProductType == Constants.ProductType.Bundle
		end

		if
			productInfo.ProductType == Constants.ProductType.CollectibleItem
			or fFlagUnifiedPurchaseOptimizeTTIMarketplace and v8
		then
			v6 = productInfo.CollectibleItemId
			v7 = productInfo.CollectibleProductId
		end

		local v9 = {
			name = productInfo.DisplayName or productInfo.Name,
			description = productInfo.Description,
			basePrice = productInfo.UserBasePriceInRobux or productInfo.BasePriceInRobux or productInfo.PriceInRobux or 0,
			price = productInfo.PriceInRobux or 0,
			priceDiscountDetails = 0,
			savingsSummaryOverride = 0,
			premiumPrice = 0,
			imageUrl = 0,
			assetTypeId = 0,
			assetType = 0,
			productId = 0,
			productType = 0,
			membershipTypeRequired = 0,
			itemType = 0,
			collectibleItemId = 0,
			collectibleItemIds = 0,
			cartPricingRequestedItems = 0,
			collectibleProductId = 0,
			productTargetId = 0,
			displayPrice = 0,
			isFreeWithRobloxPlus = 0,
			isMonthlyPrice = 0
		}

		local v10 = if normalizePriceDiscountDetails then normalizePriceDiscountDetails(productInfo.PriceDiscountDetails) else nil
		v9.priceDiscountDetails = v10

		v9.savingsSummaryOverride = productInfo.SavingsSummaryOverride
		v9.premiumPrice = productInfo.PremiumPriceInRobux
		v9.imageUrl = getPreviewImageUrl(productInfo)
		v9.assetTypeId = productInfo.AssetTypeId
		local v11 = if GetFFlagEnableCreatorStorePurchasingCutover() then productInfo.AssetType else nil
		v9.assetType = v11
		v9.productId = productInfo.ProductId
		v9.productType = productInfo.ProductType
		v9.membershipTypeRequired = productInfo.MinimumMembershipLevel
		v9.itemType = productInfo.AssetTypeId
		v9.collectibleItemId = v6

		local v12 = if fFlagPurchasePromptFetchCartPricingForLooks then productInfo.CollectibleItemIds else nil
		v9.collectibleItemIds = v12

		local v13 = if fFlagPurchasePromptFetchCartPricingForLooks then productInfo.CartPricingRequestedItems else nil
		v9.cartPricingRequestedItems = v13

		v9.collectibleProductId = v7
		local v14 = if productInfo.TargetId then productInfo.TargetId else nil
		v9.productTargetId = v14

		local v15 = if fFlagEnableUnifiedPurchaseFlowForDevSubs and productInfo.ProductType == productTypeEnum.DeveloperSubscription then productInfo.DisplayPrice else nil
		v9.displayPrice = v15

		local v16 = if fFlagLuaAppsEnablePromptVIPServerPurchase then productInfo.IsFreeWithRobloxPlus else nil
		v9.isFreeWithRobloxPlus = v16

		local v17 = if fFlagLuaAppsEnablePromptVIPServerPurchase then productInfo.IsMonthlyPrice else nil
		v9.isMonthlyPrice = v17
		return v9
	end,
	[BundleProductInfoReceived.name] = function(p2, p3)
		local bundleProductInfo = p3.bundleProductInfo
		local id = nil

		for i, item in ipairs(bundleProductInfo.items) do
			if item.type ~= "UserOutfit" then
				continue
			end

			id = item.id

			if GetFFlagFixBundlePromptThumbnail() then
				break
			end
		end

		bundleProductInfo.costumeId = id
		bundleProductInfo.itemType = ItemType.Bundle

		local name = bundleProductInfo.name

		if not name then
			name = if fFlagUnifiedPurchaseOptimizeTTIMarketplace then bundleProductInfo.Name else nil
		end

		local v7 = {
			name = name,
			basePrice = bundleProductInfo.UserBasePriceInRobux or bundleProductInfo.BasePriceInRobux or bundleProductInfo.PriceInRobux or 0,
			price = 0,
			priceDiscountDetails = 0,
			imageUrl = 0,
			assetTypeId = nil,
			productId = 0,
			membershipTypeRequired = nil,
			itemType = 0
		}

		local v8 = bundleProductInfo.product.priceInRobux

		if not v8 then
			v8 = (if fFlagUnifiedPurchaseOptimizeTTIMarketplace then bundleProductInfo.PriceInRobux else nil)
				or 0
		end

		v7.price = v8

		local v9 = if normalizePriceDiscountDetails then normalizePriceDiscountDetails(bundleProductInfo.PriceDiscountDetails) else nil
		v7.priceDiscountDetails = v9

		v7.imageUrl = getPreviewImageUrl(bundleProductInfo)

		v7.productId = bundleProductInfo.product.id

		v7.itemType = bundleProductInfo.itemType
		return v7
	end,
	[CompleteRequest.name] = function(p2, p3)
		return {}
	end
}))
