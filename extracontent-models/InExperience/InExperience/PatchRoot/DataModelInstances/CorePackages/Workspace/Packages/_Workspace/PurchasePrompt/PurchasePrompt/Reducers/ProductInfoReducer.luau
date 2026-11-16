local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local Constants = require(PurchasePrompt.Misc.Constants)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local ProductInfoReceived = require(PurchasePrompt.Actions.ProductInfoReceived)
local BundleProductInfoReceived = require(PurchasePrompt.Actions.BundleProductInfoReceived)
local ItemType = require(PurchasePrompt.Enums.ItemType)
local getPreviewImageUrl = require(PurchasePrompt.getPreviewImageUrl)

local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags.FFlagEnableUnifiedPurchaseFlowForDevSubs

local SharedFlags2 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagUnifiedPurchaseOptimizeTTIMarketplace = SharedFlags2.FFlagUnifiedPurchaseOptimizeTTIMarketplace

local GetFFlagFixBundlePromptThumbnail = require(PurchasePrompt.Flags.GetFFlagFixBundlePromptThumbnail)
local GetFFlagEnableCreatorStorePurchasingCutover = require(PurchasePrompt.Flags.GetFFlagEnableCreatorStorePurchasingCutover)
local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum
local normalizePriceDiscountDetails = require(PurchasePrompt.Utils.normalizePriceDiscountDetails)

local SharedFlags3 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagPurchasePromptFetchCartPricingForLooks = SharedFlags3.FFlagPurchasePromptFetchCartPricingForLooks

local SharedFlags4 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags4.FFlagLuaAppsEnablePromptVIPServerPurchase

return (Rodux.createReducer({}, {
	[ProductInfoReceived.name] = function(_, p)
		local productInfo = p.productInfo

		local collectibleItemId = ""
		local collectibleProductId = ""
		local v

		if FFlagUnifiedPurchaseOptimizeTTIMarketplace then
			v = productInfo.ProductType == Constants.ProductType.Asset
				or productInfo.ProductType == Constants.ProductType.Bundle
		end

		if
			productInfo.ProductType == Constants.ProductType.CollectibleItem
			or FFlagUnifiedPurchaseOptimizeTTIMarketplace and v
		then
			collectibleItemId = productInfo.CollectibleItemId
			collectibleProductId = productInfo.CollectibleProductId
		end

		local v2 = {
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
		local priceDiscountDetails

		if normalizePriceDiscountDetails then
			priceDiscountDetails = normalizePriceDiscountDetails(productInfo.PriceDiscountDetails)
		end

		v2.priceDiscountDetails = priceDiscountDetails

		v2.savingsSummaryOverride = productInfo.SavingsSummaryOverride
		v2.premiumPrice = productInfo.PremiumPriceInRobux
		v2.imageUrl = getPreviewImageUrl(productInfo)
		v2.assetTypeId = productInfo.AssetTypeId
		local assetType

		if GetFFlagEnableCreatorStorePurchasingCutover() then
			assetType = productInfo.AssetType
		end

		v2.assetType = assetType
		v2.productId = productInfo.ProductId
		v2.productType = productInfo.ProductType
		v2.membershipTypeRequired = productInfo.MinimumMembershipLevel
		v2.itemType = productInfo.AssetTypeId
		v2.collectibleItemId = collectibleItemId
		local collectibleItemIds

		if FFlagPurchasePromptFetchCartPricingForLooks then
			collectibleItemIds = productInfo.CollectibleItemIds
		end

		v2.collectibleItemIds = collectibleItemIds
		local cartPricingRequestedItems

		if FFlagPurchasePromptFetchCartPricingForLooks then
			cartPricingRequestedItems = productInfo.CartPricingRequestedItems
		end

		v2.cartPricingRequestedItems = cartPricingRequestedItems

		v2.collectibleProductId = collectibleProductId
		local productTargetId

		if productInfo.TargetId then
			productTargetId = productInfo.TargetId
		end

		v2.productTargetId = productTargetId
		local displayPrice

		if
			FFlagEnableUnifiedPurchaseFlowForDevSubs
			and productInfo.ProductType == productTypeEnum.DeveloperSubscription
		then
			displayPrice = productInfo.DisplayPrice
		end

		v2.displayPrice = displayPrice
		local isFreeWithRobloxPlus

		if FFlagLuaAppsEnablePromptVIPServerPurchase then
			isFreeWithRobloxPlus = productInfo.IsFreeWithRobloxPlus
		end

		v2.isFreeWithRobloxPlus = isFreeWithRobloxPlus
		local isMonthlyPrice

		if FFlagLuaAppsEnablePromptVIPServerPurchase then
			isMonthlyPrice = productInfo.IsMonthlyPrice
		end

		v2.isMonthlyPrice = isMonthlyPrice
		return v2
	end,
	[BundleProductInfoReceived.name] = function(_, p)
		local bundleProductInfo = p.bundleProductInfo
		local id = nil

		for _, item in ipairs(bundleProductInfo.items) do
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
			if FFlagUnifiedPurchaseOptimizeTTIMarketplace then
				name = bundleProductInfo.Name
			else
				name = nil
			end
		end

		local v = {
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

		local price = bundleProductInfo.product.priceInRobux

		if not price then
			local v2

			if FFlagUnifiedPurchaseOptimizeTTIMarketplace then
				v2 = bundleProductInfo.PriceInRobux
			end

			price = v2 or 0
		end

		v.price = price
		local priceDiscountDetails

		if normalizePriceDiscountDetails then
			priceDiscountDetails = normalizePriceDiscountDetails(bundleProductInfo.PriceDiscountDetails)
		end

		v.priceDiscountDetails = priceDiscountDetails

		v.imageUrl = getPreviewImageUrl(bundleProductInfo)

		v.productId = bundleProductInfo.product.id

		v.itemType = bundleProductInfo.itemType
		return v
	end,
	[CompleteRequest.name] = function(_, _)
		return {}
	end
}))
