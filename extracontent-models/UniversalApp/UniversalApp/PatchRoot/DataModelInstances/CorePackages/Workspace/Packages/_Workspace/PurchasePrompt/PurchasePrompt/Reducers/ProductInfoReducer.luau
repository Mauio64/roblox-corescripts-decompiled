local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local Constants = require(PurchasePrompt.Misc.Constants)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local ProductInfoReceived = require(PurchasePrompt.Actions.ProductInfoReceived)
local BundleProductInfoReceived = require(PurchasePrompt.Actions.BundleProductInfoReceived)
local ItemType = require(PurchasePrompt.Enums.ItemType)
local getPreviewImageUrl = require(PurchasePrompt.getPreviewImageUrl)
local FFlagEnableUnifiedProductPurchaseFlow = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagUnifiedPurchaseOptimizeTTIMarketplace = require(PurchasePrompt.Parent.SharedFlags).FFlagUnifiedPurchaseOptimizeTTIMarketplace
local GetFFlagTranslateDevProducts = require(PurchasePrompt.Flags.GetFFlagTranslateDevProducts)
local GetFFlagFixBundlePromptThumbnail = require(PurchasePrompt.Flags.GetFFlagFixBundlePromptThumbnail)
local GetFFlagEnableCreatorStorePurchasingCutover = require(PurchasePrompt.Flags.GetFFlagEnableCreatorStorePurchasingCutover)
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum
local FFlagEnableDiscountInfoInUnifiedPurchaseModal = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableDiscountInfoInUnifiedPurchaseModal
local v18 = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else require(PurchasePrompt.Utils.normalizePriceDiscountDetails)
local FFlagPurchasePromptFetchCartPricingForLooks = require(PurchasePrompt.Parent.SharedFlags).FFlagPurchasePromptFetchCartPricingForLooks

return (Rodux.createReducer({}, {
	[ProductInfoReceived.name] = function(_, p2) -- line: 35
		-- upvalues: FFlagUnifiedPurchaseOptimizeTTIMarketplace (copy), Constants (copy), GetFFlagTranslateDevProducts (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), v18 (copy), getPreviewImageUrl (copy), GetFFlagEnableCreatorStorePurchasingCutover (copy), FFlagPurchasePromptFetchCartPricingForLooks (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), ProductTypeEnum (copy)
		local productInfo = p2.productInfo
		local s1 = ""
		local s2 = ""
		local v25 = nil

		if FFlagUnifiedPurchaseOptimizeTTIMarketplace then
			v25 = productInfo.ProductType == Constants.ProductType.Asset or productInfo.ProductType == Constants.ProductType.Bundle
		end

		if productInfo.ProductType == Constants.ProductType.CollectibleItem or FFlagUnifiedPurchaseOptimizeTTIMarketplace and v25 then
			s1 = productInfo.CollectibleItemId
			s2 = productInfo.CollectibleProductId
		end

		return {
			name = GetFFlagTranslateDevProducts() and (productInfo.DisplayName or productInfo.Name) or productInfo.Name,
			description = productInfo.Description,
			basePrice = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else productInfo.UserBasePriceInRobux or (productInfo.BasePriceInRobux or (productInfo.PriceInRobux or 0)),
			price = productInfo.PriceInRobux or 0,
			priceDiscountDetails = if not v18 then nil else v18(productInfo.PriceDiscountDetails),
			premiumPrice = productInfo.PremiumPriceInRobux,
			imageUrl = getPreviewImageUrl(productInfo),
			assetTypeId = productInfo.AssetTypeId,
			assetType = if not GetFFlagEnableCreatorStorePurchasingCutover() then nil else productInfo.AssetType,
			productId = productInfo.ProductId,
			productType = productInfo.ProductType,
			membershipTypeRequired = productInfo.MinimumMembershipLevel,
			itemType = productInfo.AssetTypeId,
			collectibleItemId = s1,
			collectibleItemIds = if not FFlagPurchasePromptFetchCartPricingForLooks then nil else productInfo.CollectibleItemIds,
			cartPricingRequestedItems = if not FFlagPurchasePromptFetchCartPricingForLooks then nil else productInfo.CartPricingRequestedItems,
			collectibleProductId = s2,
			productTargetId = if not FFlagEnableUnifiedProductPurchaseFlow or not productInfo.TargetId then nil else productInfo.TargetId,
			displayPrice = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or productInfo.ProductType ~= ProductTypeEnum.DeveloperSubscription then nil else productInfo.DisplayPrice
		}
	end,
	[BundleProductInfoReceived.name] = function(_, p4) -- line: 93
		-- upvalues: GetFFlagFixBundlePromptThumbnail (copy), ItemType (copy), FFlagUnifiedPurchaseOptimizeTTIMarketplace (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), v18 (copy), getPreviewImageUrl (copy)
		local bundleProductInfo = p4.bundleProductInfo
		local id = nil

		for _, v in ipairs(bundleProductInfo.items) do
			if v.type == "UserOutfit" then
				id = v.id

				if GetFFlagFixBundlePromptThumbnail() then
					break
				end
			end
		end

		bundleProductInfo.costumeId = id
		bundleProductInfo.itemType = ItemType.Bundle

		return {
			assetTypeId = nil,
			membershipTypeRequired = nil,
			name = bundleProductInfo.name or if not FFlagUnifiedPurchaseOptimizeTTIMarketplace then nil else bundleProductInfo.Name,
			basePrice = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else bundleProductInfo.UserBasePriceInRobux or (bundleProductInfo.BasePriceInRobux or (bundleProductInfo.PriceInRobux or 0)),
			price = bundleProductInfo.product.priceInRobux or (((if not FFlagUnifiedPurchaseOptimizeTTIMarketplace then nil else bundleProductInfo.PriceInRobux)) or 0),
			priceDiscountDetails = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal or not v18 then nil else v18(bundleProductInfo.PriceDiscountDetails),
			imageUrl = getPreviewImageUrl(bundleProductInfo),
			productId = bundleProductInfo.product.id,
			itemType = bundleProductInfo.itemType
		}
	end,
	[CompleteRequest.name] = function(_, _) -- line: 133
		return {}
	end
}))
