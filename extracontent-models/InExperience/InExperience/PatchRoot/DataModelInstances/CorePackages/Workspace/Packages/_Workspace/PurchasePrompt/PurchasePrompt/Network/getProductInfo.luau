local parent = script.Parent.Parent

local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)
require(parent.Parent.LuauPolyfill)
local IAPExperience = require(parent.Parent.IAPExperience)
local getAssetInfo = require(parent.Network.getAssetInfo)
local getCreatorStoreProductInfo = require(parent.Network.getCreatorStoreProductInfo)
require(parent.Misc.Constants)
local isCreatorStoreAssetType = require(parent.Utils.isCreatorStoreAssetType)
local getAssetInfoUtil = require(parent.Utils.getAssetInfoUtil)
local getCreatorStoreProductInfoUtil = require(parent.Utils.getCreatorStoreProductInfoUtil)
local getExperienceProductInfoUtil = require(parent.Utils.getExperienceProductInfoUtil)
local getExperienceProductImageUrl = require(parent.Utils.getExperienceProductImageUrl)
local FFlagExperiencePurchaseFallbackToGameIcon = require(parent.Flags.FFlagExperiencePurchaseFallbackToGameIcon)
local handleLooksProductInfoResult = require(parent.Utils.handleLooksProductInfoResult)
local types = require(parent.types)
local productTypeEnum = types.ProductTypeEnum

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagEnableFetchCartPricingDuringInExperience = SharedFlags.FFlagEnableFetchCartPricingDuringInExperience

local SharedFlags2 = require(parent.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags2.FFlagEnableUnifiedPurchaseFlowForDevSubs

local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require(parent.Flags.FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell)

local SharedFlags3 = require(parent.Parent.SharedFlags)
local GetFFlagDiscountInfoForSubscriptionPurchaseModalLua = SharedFlags3.GetFFlagDiscountInfoForSubscriptionPurchaseModalLua

local SharedFlags4 = require(parent.Parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags4.FFlagLuaAppsEnablePromptVIPServerPurchase
local FFlagRefreshPriceOnRetryAfterUpsell = require(parent.Flags.FFlagRefreshPriceOnRetryAfterUpsell)
local FFlagRefreshLookPriceOnRetryAfterUpsell = require(parent.Flags.FFlagRefreshLookPriceOnRetryAfterUpsell)
local getCatalogItemDetails = require(parent.Network.getCatalogItemDetails)
local getResellers = require(parent.Network.getResellers)
local getUniversePrivateServerSettings = require(parent.Network.getUniversePrivateServerSettings)
local resolveRefreshedExpectedPrice = require(parent.Utils.resolveRefreshedExpectedPrice)
local FFlagFixTimedOptionRefresh = require(parent.Flags.FFlagFixTimedOptionRefresh)
local resolveRefreshedProductInfo = require(parent.Utils.resolveRefreshedProductInfo)

local function fetchRefreshedPrice(data, p, p2: string, data2)
	local collectibleItemId = data2.collectibleItemId
	local collectibleItemInstanceId = data2.collectibleItemInstanceId
	local all = Promise.all
	local v = {
		catalogItemDetails = getCatalogItemDetails(data, p, p2):catch(function(): nil
			return nil
		end),
		resellersData = 0
	}
	local resellersData

	if
		collectibleItemInstanceId
		and collectibleItemInstanceId ~= ""
		and collectibleItemId
		and collectibleItemId ~= ""
	then
		resellersData = getResellers(data, collectibleItemId, 10):catch(function(): nil
			return nil
		end)
	else
		resellersData = Promise.resolve(nil)
	end

	v.resellersData = resellersData
	return all(v):andThen(function(p3)
		if FFlagFixTimedOptionRefresh then
			return resolveRefreshedProductInfo(
				p3.catalogItemDetails,
				p3.resellersData,
				collectibleItemInstanceId,
				data2.timedOptionDays
			)
		end

		return (resolveRefreshedExpectedPrice(
			p3.catalogItemDetails,
			p3.resellersData,
			collectibleItemInstanceId,
			data2.timedOptionDays
		))
	end)
end

local function getProductInfo(data, p, p2, data2, p3, callback)
	if p2 == Enum.InfoType.Asset then
		local productInfo2 = getAssetInfo(data, p):andThen(function(p4)
			local v

			if p4 and p4.data and p4.data[1] then
				if not getAssetInfoUtil.isAssetValid(p4.data[1]) then
					return Promise.reject(PurchaseError.UnknownFailureNoItemName)
				end

				v = getAssetInfoUtil.fromAsset(p4.data[1])
			else
				v = nil
			end

			local kind = v and v.type or ""

			if isCreatorStoreAssetType(kind) then
				return getCreatorStoreProductInfo(data, p, kind):andThen(function(p5)
					local v2 = getCreatorStoreProductInfoUtil.fromProduct(p5)
					return {
						AssetId = v.id,
						AssetType = kind,
						AssetTypeId = v.typeId,
						Creator = {
							CreatorTargetId = v.creator.targetId,
							CreatorType = v.creator.type
						},
						Description = v.description,
						IsFiatPriced = v2.basePrice and v2.basePrice.quantity and v2.basePrice.quantity.significand ~= 0,
						IsForSale = v2.purchasable,
						IsPublicDomain = v.isPublicDomainEnabled,
						Name = v.name,
						PriceInRobux = 0,
						ProductId = v.id
					}
				end)
			end

			if FFlagEnableFetchCartPricingDuringInExperience then
				return data.getProductInfo(p, p2):andThen(function(p5)
					if p5.CollectibleItemId and callback then
						return callback(p5.CollectibleItemId):andThen(function()
							return p5
						end):catch(function()
							return p5
						end)
					end

					return p5
				end):catch(function(_)
					return Promise.reject(PurchaseError.UnknownFailureNoItemName)
				end)
			end

			return data.getProductInfo(p, p2):catch(function(_)
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end)
		end):catch(function(_)
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end)

		if FFlagRefreshPriceOnRetryAfterUpsell and p3 then
			return Promise.all({
				productInfo = productInfo2,
				refreshedPrice = fetchRefreshedPrice(data, p, "asset", p3)
			}):andThen(function(p4)
				local productInfo = p4.productInfo

				if FFlagFixTimedOptionRefresh then
					local refreshedPrice = p4.refreshedPrice

					if refreshedPrice ~= nil then
						for k, v in pairs(refreshedPrice) do
							productInfo[k] = v
						end

						return productInfo
					end
				elseif p4.refreshedPrice ~= nil then
					productInfo.refreshedExpectedPrice = p4.refreshedPrice
				end

				return productInfo
			end)
		end

		return productInfo2
	end

	if p2 == productTypeEnum.Experience then
		return data.getExperienceProductInfo(p):andThen(function(p4)
			if not (p4 and p4.data and p4.data[1] and data2.name and (FFlagExperiencePurchaseFallbackToGameIcon or data2.imageUrl)) then
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end

			local v = getExperienceProductInfoUtil.fromProduct(p4.data[1])
			local imageUrl = data2.imageUrl

			if FFlagExperiencePurchaseFallbackToGameIcon then
				imageUrl = getExperienceProductImageUrl(data2.imageUrl, p)
			end

			return {
				IsForSale = v.isForSale,
				PriceInRobux = v.price,
				ProductId = v.productId,
				SellerId = v.sellerId,
				Name = data2.name,
				ImageUrl = imageUrl
			}
		end):catch(function(_)
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end)
	end

	if p2 == productTypeEnum.Look then
		if FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then
			return data.GetLookDetailsV2ProductInfo(p):andThen(function(p4)
				local v = handleLooksProductInfoResult(p4, data2)

				if not v then
					return Promise.reject(PurchaseError.UnknownFailureNoItemName)
				end

				if FFlagRefreshLookPriceOnRetryAfterUpsell then
					v.refreshedExpectedPrice = v.PriceInRobux
				end

				return v
			end):catch(function()
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end)
		end

		return Promise.resolve({
			PriceInRobux = data2.expectedPrice,
			IsForSale = true,
			Name = "Looks"
		})
	end

	if FFlagEnableUnifiedPurchaseFlowForDevSubs and p2 == productTypeEnum.DeveloperSubscription then
		return data.getSubscriptionProductInfo(p):andThen(function(data3)
			if not (data3 and data3.Name) then
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end

			local fFlagDiscountInfoForSubscriptionPurchaseModalLua = GetFFlagDiscountInfoForSubscriptionPurchaseModalLua()
			local userBasePriceInRobux

			if fFlagDiscountInfoForSubscriptionPurchaseModalLua then
				userBasePriceInRobux = data3.UserBasePriceInRobux
			end

			local priceDiscountDetails

			if fFlagDiscountInfoForSubscriptionPurchaseModalLua then
				priceDiscountDetails = data3.PriceDiscountDetails
			end

			return {
				Name = data3.Name,
				Description = data3.Description,
				IconImageAssetId = data3.IconImageAssetId,
				IsForSale = data3.IsForSale,
				DisplayPrice = data3.DisplayPrice,
				SubscriptionProviderName = data3.SubscriptionProviderName,
				PriceInRobux = data3.PriceInRobux,
				PriceTier = data3.PriceTier,
				ProductType = productTypeEnum.DeveloperSubscription,
				UserBasePriceInRobux = userBasePriceInRobux,
				PriceDiscountDetails = priceDiscountDetails
			}
		end):catch(function(_)
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end)
	end

	if FFlagLuaAppsEnablePromptVIPServerPurchase and p2 == productTypeEnum.VIPServer then
		return getUniversePrivateServerSettings(data, p):andThen(function(p4)
			local privateServerData = p4.privateServerData
			local total = 0

			for _, v in privateServerData.discounts or {} do
				if v.source == "RobloxSubscription" and v.robux > 0 then
					total += v.robux
				end
			end

			local price = privateServerData.price or 0
			local isFreeWithRobloxPlus

			if price == 0 then
				isFreeWithRobloxPlus = total > 0
			else
				isFreeWithRobloxPlus = false
			end

			local userBasePriceInRobux, priceDiscountDetails

			if total > 0 then
				userBasePriceInRobux = price + total

				priceDiscountDetails = {
					{
						Type = IAPExperience.DiscountType.RobloxPlusSubscription,
						AmountInRobux = total,
						Percent = math.floor(total * 100 / userBasePriceInRobux)
					}
				}
			else
				userBasePriceInRobux = nil
				priceDiscountDetails = nil
			end

			return data.getProductInfo(p4.rootPlaceId, Enum.InfoType.Asset):andThen(function(p5)
				return {
					IsForSale = true,
					PriceInRobux = privateServerData.price,
					UserBasePriceInRobux = userBasePriceInRobux,
					PriceDiscountDetails = priceDiscountDetails,
					ProductId = privateServerData.privateServerProductId,
					Name = p5.Name,
					ImageUrl = getExperienceProductImageUrl(nil, p),
					IsFreeWithRobloxPlus = isFreeWithRobloxPlus,
					IsMonthlyPrice = true,
					Creator = {
						CreatorType = game.CreatorType == Enum.CreatorType.Group and "Group" or "User",
						CreatorTargetId = game.CreatorId
					}
				}
			end):catch(function()
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end)
		end)
	end

	return data.getProductInfo(p, p2):catch(function(_)
		return Promise.reject(PurchaseError.UnknownFailureNoItemName)
	end)
end

return getProductInfo
