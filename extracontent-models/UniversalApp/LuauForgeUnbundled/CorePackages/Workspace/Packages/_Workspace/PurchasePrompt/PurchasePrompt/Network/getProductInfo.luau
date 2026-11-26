local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LuauPolyfill")
local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local getAssetInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getAssetInfo")
local getCreatorStoreProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getCreatorStoreProductInfo")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local isCreatorStoreAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isCreatorStoreAssetType")
local getAssetInfoUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getAssetInfoUtil")
local getCreatorStoreProductInfoUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getCreatorStoreProductInfoUtil")
local getExperienceProductInfoUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getExperienceProductInfoUtil")
local getExperienceProductImageUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getExperienceProductImageUrl")
local FFlagExperiencePurchaseFallbackToGameIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagExperiencePurchaseFallbackToGameIcon")
local handleLooksProductInfoResult = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/handleLooksProductInfoResult")
local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum

local fFlagEnableFetchCartPricingDuringInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableFetchCartPricingDuringInExperience

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell")

local getFFlagDiscountInfoForSubscriptionPurchaseModalLua = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").GetFFlagDiscountInfoForSubscriptionPurchaseModalLua

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase
local FFlagRefreshPriceOnRetryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagRefreshPriceOnRetryAfterUpsell")
local FFlagRefreshLookPriceOnRetryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagRefreshLookPriceOnRetryAfterUpsell")
local getCatalogItemDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getCatalogItemDetails")
local getResellers = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getResellers")
local getUniversePrivateServerSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getUniversePrivateServerSettings")
local resolveRefreshedExpectedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/resolveRefreshedExpectedPrice")
local FFlagFixTimedOptionRefresh = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagFixTimedOptionRefresh")
local resolveRefreshedProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/resolveRefreshedProductInfo")

local function fetchRefreshedPrice(data, p2, p3, data2)
	local collectibleItemId = data2.collectibleItemId
	local collectibleItemInstanceId = data2.collectibleItemInstanceId
	local all = Promise.all
	local v5 = {
		catalogItemDetails = getCatalogItemDetails(data, p2, p3):catch(function(): nil
			return nil
		end),
		resellersData = 0
	}
	local v6

	if
		collectibleItemInstanceId
		and collectibleItemInstanceId ~= ""
		and collectibleItemId
		and collectibleItemId ~= ""
	then
		v6 = getResellers(data, collectibleItemId, 10):catch(function(): nil
			return nil
		end)
	else
		v6 = Promise.resolve(nil)
	end

	v5.resellersData = v6
	return all(v5):andThen(function(p4)
		if FFlagFixTimedOptionRefresh then
			return resolveRefreshedProductInfo(
				p4.catalogItemDetails,
				p4.resellersData,
				collectibleItemInstanceId,
				data2.timedOptionDays
			)
		end

		return resolveRefreshedExpectedPrice(
			p4.catalogItemDetails,
			p4.resellersData,
			collectibleItemInstanceId,
			data2.timedOptionDays
		)
	end)
end

local function getProductInfo(data, p2, p3, data2, p4, callback)
	if p3 == Enum.InfoType.Asset then
		local v5 = getAssetInfo(data, p2):andThen(function(p5)
			local v6

			if p5 and p5.data and p5.data[1] then
				if not getAssetInfoUtil.isAssetValid(p5.data[1]) then
					return Promise.reject(PurchaseError.UnknownFailureNoItemName)
				end

				v6 = getAssetInfoUtil.fromAsset(p5.data[1])
			else
				v6 = nil
			end

			local kind = v6 and v6.type or ""

			if isCreatorStoreAssetType(kind) then
				return getCreatorStoreProductInfo(data, p2, kind):andThen(function(p6)
					local v7 = getCreatorStoreProductInfoUtil.fromProduct(p6)
					return {
						AssetId = v6.id,
						AssetType = kind,
						AssetTypeId = v6.typeId,
						Creator = {
							CreatorTargetId = v6.creator.targetId,
							CreatorType = v6.creator.type
						},
						Description = v6.description,
						IsFiatPriced = v7.basePrice and v7.basePrice.quantity and v7.basePrice.quantity.significand ~= 0,
						IsForSale = v7.purchasable,
						IsPublicDomain = v6.isPublicDomainEnabled,
						Name = v6.name,
						PriceInRobux = 0,
						ProductId = v6.id
					}
				end)
			end

			if fFlagEnableFetchCartPricingDuringInExperience then
				return data.getProductInfo(p2, p3):andThen(function(p6)
					if p6.CollectibleItemId and callback then
						return callback(p6.CollectibleItemId):andThen(function()
							return p6
						end):catch(function()
							return p6
						end)
					end

					return p6
				end):catch(function(p6)
					return Promise.reject(PurchaseError.UnknownFailureNoItemName)
				end)
			end

			return data.getProductInfo(p2, p3):catch(function(p6)
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end)
		end):catch(function(p5)
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end)

		if FFlagRefreshPriceOnRetryAfterUpsell and p4 then
			return Promise.all({
				productInfo = v5,
				refreshedPrice = fetchRefreshedPrice(data, p2, "asset", p4)
			}):andThen(function(p5)
				local productInfo = p5.productInfo

				if FFlagFixTimedOptionRefresh then
					local refreshedPrice = p5.refreshedPrice

					if refreshedPrice ~= nil then
						for k, v6 in pairs(refreshedPrice) do
							productInfo[k] = v6
						end

						return productInfo
					end
				elseif p5.refreshedPrice ~= nil then
					productInfo.refreshedExpectedPrice = p5.refreshedPrice
				end

				return productInfo
			end)
		end

		return v5
	end

	if p3 == productTypeEnum.Experience then
		return data.getExperienceProductInfo(p2):andThen(function(p5)
			if not (p5 and p5.data and p5.data[1] and data2.name and (FFlagExperiencePurchaseFallbackToGameIcon or data2.imageUrl)) then
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end

			local v5 = getExperienceProductInfoUtil.fromProduct(p5.data[1])
			local v6 = data2.imageUrl

			if FFlagExperiencePurchaseFallbackToGameIcon then
				v6 = getExperienceProductImageUrl(data2.imageUrl, p2)
			end

			return {
				IsForSale = v5.isForSale,
				PriceInRobux = v5.price,
				ProductId = v5.productId,
				SellerId = v5.sellerId,
				Name = data2.name,
				ImageUrl = v6
			}
		end):catch(function(p5)
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end)
	end

	if p3 == productTypeEnum.Look then
		if FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then
			return data.GetLookDetailsV2ProductInfo(p2):andThen(function(p5)
				local v5 = handleLooksProductInfoResult(p5, data2)

				if not v5 then
					return Promise.reject(PurchaseError.UnknownFailureNoItemName)
				end

				if FFlagRefreshLookPriceOnRetryAfterUpsell then
					v5.refreshedExpectedPrice = v5.PriceInRobux
				end

				return v5
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

	if fFlagEnableUnifiedPurchaseFlowForDevSubs and p3 == productTypeEnum.DeveloperSubscription then
		return data.getSubscriptionProductInfo(p2):andThen(function(data3)
			if not (data3 and data3.Name) then
				return Promise.reject(PurchaseError.UnknownFailureNoItemName)
			end

			local fFlagDiscountInfoForSubscriptionPurchaseModalLua = getFFlagDiscountInfoForSubscriptionPurchaseModalLua()
			local userBasePriceInRobux

			if fFlagDiscountInfoForSubscriptionPurchaseModalLua then
				userBasePriceInRobux = data3.UserBasePriceInRobux
			end

			local v5 = if fFlagDiscountInfoForSubscriptionPurchaseModalLua then data3.PriceDiscountDetails else nil
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
				PriceDiscountDetails = v5
			}
		end):catch(function(p5)
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end)
	end

	if fFlagLuaAppsEnablePromptVIPServerPurchase and p3 == productTypeEnum.VIPServer then
		return getUniversePrivateServerSettings(data, p2):andThen(function(p5)
			local privateServerData = p5.privateServerData
			local total = 0

			for k, v5 in privateServerData.discounts or {} do
				if v5.source == "RobloxSubscription" and v5.robux > 0 then
					total += v5.robux
				end
			end

			local price = privateServerData.price or 0
			local v5 = price == 0 and total > 0
			local v6, v7

			if total > 0 then
				v6 = price + total

				v7 = {
					{
						Type = IAPExperience.DiscountType.RobloxPlusSubscription,
						AmountInRobux = total,
						Percent = math.floor(total * 100 / v6)
					}
				}
			else
				v6 = nil
				v7 = nil
			end

			return data.getProductInfo(p5.rootPlaceId, Enum.InfoType.Asset):andThen(function(p6)
				return {
					IsForSale = true,
					PriceInRobux = privateServerData.price,
					UserBasePriceInRobux = v6,
					PriceDiscountDetails = v7,
					ProductId = privateServerData.privateServerProductId,
					Name = p6.Name,
					ImageUrl = getExperienceProductImageUrl(nil, p2),
					IsFreeWithRobloxPlus = v5,
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

	return data.getProductInfo(p2, p3):catch(function(p5)
		return Promise.reject(PurchaseError.UnknownFailureNoItemName)
	end)
end

return getProductInfo
