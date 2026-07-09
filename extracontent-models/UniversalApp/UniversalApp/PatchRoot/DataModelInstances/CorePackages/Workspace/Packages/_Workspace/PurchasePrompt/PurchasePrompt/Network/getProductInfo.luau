local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)
local getAssetInfo = require(ParentParent.Network.getAssetInfo)
local getCreatorStoreProductInfo = require(ParentParent.Network.getCreatorStoreProductInfo)

require(ParentParent.Misc.Constants)

local isCreatorStoreAssetType = require(ParentParent.Utils.isCreatorStoreAssetType)
local getAssetInfoUtil = require(ParentParent.Utils.getAssetInfoUtil)
local getCreatorStoreProductInfoUtil = require(ParentParent.Utils.getCreatorStoreProductInfoUtil)
local getExperienceProductInfoUtil = require(ParentParent.Utils.getExperienceProductInfoUtil)
local handleLooksProductInfoResult = require(ParentParent.Utils.handleLooksProductInfoResult)
local ProductTypeEnum = require(ParentParent.types).ProductTypeEnum
local FFlagEnableUnifiedProductPurchaseFlow = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require(ParentParent.Flags.FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell)
local GetFFlagDiscountInfoForSubscriptionPurchaseModalLua = require(ParentParent.Parent.SharedFlags).GetFFlagDiscountInfoForSubscriptionPurchaseModalLua
local FFlagRefreshPriceOnRetryAfterUpsell = require(ParentParent.Flags.FFlagRefreshPriceOnRetryAfterUpsell)
local FFlagRefreshLookPriceOnRetryAfterUpsell = require(ParentParent.Flags.FFlagRefreshLookPriceOnRetryAfterUpsell)
local getCatalogItemDetails = require(ParentParent.Network.getCatalogItemDetails)
local getResellers = require(ParentParent.Network.getResellers)
local resolveRefreshedExpectedPrice = require(ParentParent.Utils.resolveRefreshedExpectedPrice)
local FFlagFixTimedOptionRefresh = require(ParentParent.Flags.FFlagFixTimedOptionRefresh)
local resolveRefreshedProductInfo = require(ParentParent.Utils.resolveRefreshedProductInfo)

local function fetchRefreshedPrice(p1, p2, s1: string, t1: {[any]: any}) -- line: 37
	-- upvalues: Promise (copy), getCatalogItemDetails (copy), getResellers (copy), FFlagFixTimedOptionRefresh (copy), resolveRefreshedProductInfo (copy), resolveRefreshedExpectedPrice (copy)
	local collectibleItemId = t1.collectibleItemId
	local collectibleItemInstanceId = t1.collectibleItemInstanceId

	return Promise.all({
		catalogItemDetails = getCatalogItemDetails(p1, p2, s1):catch(function() -- line: 41
			return nil
		end),
		resellersData = if not collectibleItemInstanceId or (collectibleItemInstanceId == "" or (not collectibleItemId or collectibleItemId == "")) then Promise.resolve(nil) else getResellers(p1, collectibleItemId, 10):catch(function() -- line: 48
			return nil
		end)
	}):andThen(function(p3) -- line: 52
		-- upvalues: FFlagFixTimedOptionRefresh (copy), resolveRefreshedProductInfo (copy), collectibleItemInstanceId (copy), t1 (copy), resolveRefreshedExpectedPrice (copy)
		if FFlagFixTimedOptionRefresh then
			return resolveRefreshedProductInfo(p3.catalogItemDetails, p3.resellersData, collectibleItemInstanceId, t1.timedOptionDays)
		end

		return (resolveRefreshedExpectedPrice(p3.catalogItemDetails, p3.resellersData, collectibleItemInstanceId, t1.timedOptionDays))
	end)
end
local function getProductInfo(p4, p5, p6, p7, t2: {[any]: any}?) -- line: 70
	-- upvalues: getAssetInfo (copy), getAssetInfoUtil (copy), Promise (copy), PurchaseError (copy), isCreatorStoreAssetType (copy), getCreatorStoreProductInfo (copy), getCreatorStoreProductInfoUtil (copy), FFlagRefreshPriceOnRetryAfterUpsell (copy), fetchRefreshedPrice (copy), FFlagFixTimedOptionRefresh (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), ProductTypeEnum (copy), getExperienceProductInfoUtil (copy), FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell (copy), handleLooksProductInfoResult (copy), FFlagRefreshLookPriceOnRetryAfterUpsell (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), GetFFlagDiscountInfoForSubscriptionPurchaseModalLua (copy)
	if p6 == Enum.InfoType.Asset then
		local v36 = getAssetInfo(p4, p5):andThen(function(p8) -- line: 73
			-- upvalues: getAssetInfoUtil (copy), Promise (copy), PurchaseError (copy), isCreatorStoreAssetType (copy), getCreatorStoreProductInfo (copy), p4 (copy), p5 (copy), getCreatorStoreProductInfoUtil (copy), p6 (copy)
			local u39 = nil

			if p8 and (p8.data and p8.data[1]) then
				if not getAssetInfoUtil.isAssetValid(p8.data[1]) then
					return Promise.reject(PurchaseError.UnknownFailureNoItemName)
				end

				u39 = getAssetInfoUtil.fromAsset(p8.data[1])
			end

			local v40 = u39 and u39.type or ""

			if isCreatorStoreAssetType(v40) then
				return getCreatorStoreProductInfo(p4, p5, v40):andThen(function(p9) -- line: 84
					-- upvalues: getCreatorStoreProductInfoUtil (copy), u39 (ref), v40 (copy)
					local v59 = getCreatorStoreProductInfoUtil.fromProduct(p9)

					return {
						PriceInRobux = 0,
						AssetId = u39.id,
						AssetType = v40,
						AssetTypeId = u39.typeId,
						Creator = {
							CreatorTargetId = u39.creator.targetId,
							CreatorType = u39.creator.type
						},
						Description = u39.description,
						IsFiatPriced = v59.basePrice and (v59.basePrice.quantity and v59.basePrice.quantity.significand ~= 0),
						IsForSale = v59.purchasable,
						IsPublicDomain = u39.isPublicDomainEnabled,
						Name = u39.name,
						ProductId = u39.id
					}
				end)
			end

			return p4.getProductInfo(p5, p6):catch(function(_) -- line: 108
				-- upvalues: Promise (copy), PurchaseError (copy)
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end)
		end):catch(function(_) -- line: 113
			-- upvalues: Promise (copy), PurchaseError (copy)
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end)

		if FFlagRefreshPriceOnRetryAfterUpsell and t2 then
			return Promise.all({
				productInfo = v36,
				refreshedPrice = fetchRefreshedPrice(p4, p5, "asset", t2)
			}):andThen(function(p12) -- line: 127
				-- upvalues: FFlagFixTimedOptionRefresh (copy)
				local productInfo = p12.productInfo

				if FFlagFixTimedOptionRefresh then
					local refreshedPrice = p12.refreshedPrice

					if refreshedPrice ~= nil then
						for k, v in pairs(refreshedPrice) do
							productInfo[k] = v
						end

						return productInfo
					end
				elseif p12.refreshedPrice ~= nil then
					productInfo.refreshedExpectedPrice = p12.refreshedPrice
				end

				return productInfo
			end)
		end

		return v36
	end

	if FFlagEnableUnifiedProductPurchaseFlow and p6 == ProductTypeEnum.Experience then
		return p4.getExperienceProductInfo(p5):andThen(function(p13) -- line: 149
			-- upvalues: p7 (copy), getExperienceProductInfoUtil (copy), Promise (copy), PurchaseError (copy)
			if p13 and (p13.data and p13.data[1] and p7.name and p7.imageUrl) then
				local v48 = getExperienceProductInfoUtil.fromProduct(p13.data[1])

				return {
					IsForSale = v48.isForSale,
					PriceInRobux = v48.price,
					ProductId = v48.productId,
					SellerId = v48.sellerId,
					Name = p7.name,
					ImageUrl = p7.imageUrl
				}
			end

			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end):catch(function(_) -- line: 169
			-- upvalues: Promise (copy), PurchaseError (copy)
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end)
	end

	if FFlagEnableUnifiedProductPurchaseFlow and p6 == ProductTypeEnum.Look then
		if FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then
			return p4.GetLookDetailsV2ProductInfo(p5):andThen(function(p15) -- line: 176
				-- upvalues: handleLooksProductInfoResult (copy), p7 (copy), Promise (copy), PurchaseError (copy), FFlagRefreshLookPriceOnRetryAfterUpsell (copy)
				local v51 = handleLooksProductInfoResult(p15, p7)

				if not v51 then
					return Promise.reject(PurchaseError.UnknownFailureNoItemName)
				end

				if FFlagRefreshLookPriceOnRetryAfterUpsell then
					v51.refreshedExpectedPrice = v51.PriceInRobux
				end

				return v51
			end):catch(function() -- line: 187
				-- upvalues: Promise (copy), PurchaseError (copy)
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end)
		end

		return Promise.resolve({
			IsForSale = true,
			Name = "Looks",
			PriceInRobux = p7.expectedPrice
		})
	end

	if FFlagEnableUnifiedPurchaseFlowForDevSubs and p6 == ProductTypeEnum.DeveloperSubscription then
		return p4.getSubscriptionProductInfo(p5):andThen(function(p16) -- line: 199
			-- upvalues: GetFFlagDiscountInfoForSubscriptionPurchaseModalLua (copy), ProductTypeEnum (copy), Promise (copy), PurchaseError (copy)
			if p16 and p16.Name then
				local v53 = GetFFlagDiscountInfoForSubscriptionPurchaseModalLua()
				local v54 = if not v53 then nil else p16.UserBasePriceInRobux
				local v55 = if not v53 then nil else p16.PriceDiscountDetails

				return {
					Name = p16.Name,
					Description = p16.Description,
					IconImageAssetId = p16.IconImageAssetId,
					IsForSale = p16.IsForSale,
					DisplayPrice = p16.DisplayPrice,
					SubscriptionProviderName = p16.SubscriptionProviderName,
					PriceInRobux = p16.PriceInRobux,
					PriceTier = p16.PriceTier,
					ProductType = ProductTypeEnum.DeveloperSubscription,
					UserBasePriceInRobux = v54,
					PriceDiscountDetails = v55
				}
			end

			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end):catch(function(_) -- line: 220
			-- upvalues: Promise (copy), PurchaseError (copy)
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end)
	end

	return p4.getProductInfo(p5, p6):catch(function(_) -- line: 224
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailureNoItemName)
	end)
end

return getProductInfo
