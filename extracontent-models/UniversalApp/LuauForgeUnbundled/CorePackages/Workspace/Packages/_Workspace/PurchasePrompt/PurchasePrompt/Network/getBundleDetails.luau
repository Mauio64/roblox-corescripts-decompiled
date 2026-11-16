local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LuauPolyfill")

local FFlagRefreshPriceOnRetryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagRefreshPriceOnRetryAfterUpsell")

local fFlagEnableFetchCartPricingDuringInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableFetchCartPricingDuringInExperience
local getCatalogItemDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getCatalogItemDetails")
local getResellers = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getResellers")
local resolveRefreshedExpectedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/resolveRefreshedExpectedPrice")
local FFlagFixTimedOptionRefresh = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagFixTimedOptionRefresh")
local resolveRefreshedProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/resolveRefreshedProductInfo")

local function convertDiscountInfoToPriceDiscountDetails(discountInformation)
	if not discountInformation or type(discountInformation.discounts) ~= "table" then
		return nil
	end

	local result = {}

	for i, discount in ipairs(discountInformation.discounts) do
		table.insert(result, {
			Type = discount.discountCampaign,
			AmountInRobux = discount.robuxDiscountAmount,
			Percent = discount.robuxDiscountPercentage
		})
	end

	return result
end

local function normalizeBundleFields(state)
	if not state.UserBasePriceInRobux then
		local discountInformation = state.discountInformation
		local v5 = state.BasePriceInRobux

		if not v5 then
			v5 = (if discountInformation then discountInformation.originalPrice else nil)
				or state.PriceInRobux

			if not v5 then
				v5 = (if state.product then state.product.priceInRobux else nil) or 0
			end
		end

		state.UserBasePriceInRobux = v5
	end

	if not state.PriceDiscountDetails and state.discountInformation then
		state.PriceDiscountDetails = convertDiscountInfoToPriceDiscountDetails(state.discountInformation)
	end

	return state
end

local function getBundleDetails(p2, p3, data, callback)
	local v5 = p2.getBundleDetails(p3):andThen(function(p4)
		if
			fFlagEnableFetchCartPricingDuringInExperience
			and p4.collectibleItemDetail
			and p4.collectibleItemDetail.collectibleItemId
			and callback
		then
			return callback(p4.collectibleItemDetail.collectibleItemId):andThen(function()
				return normalizeBundleFields(p4)
			end):catch(function()
				return normalizeBundleFields(p4)
			end)
		end

		return Promise.resolve(normalizeBundleFields(p4))
	end):catch(function(p4)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)

	if not (FFlagRefreshPriceOnRetryAfterUpsell and data) then
		return v5
	end

	local collectibleItemId = data.collectibleItemId
	local collectibleItemInstanceId = data.collectibleItemInstanceId

	local all = Promise.all
	local v6 = {
		catalogItemDetails = getCatalogItemDetails(p2, p3, "bundle"):catch(function(): nil
			return nil
		end),
		resellersData = 0
	}
	local v7

	if
		collectibleItemInstanceId
		and collectibleItemInstanceId ~= ""
		and collectibleItemId
		and collectibleItemId ~= ""
	then
		v7 = getResellers(p2, collectibleItemId, 10):catch(function(): nil
			return nil
		end)
	else
		v7 = Promise.resolve(nil)
	end

	v6.resellersData = v7
	local v8 = all(v6):andThen(function(p4)
		if FFlagFixTimedOptionRefresh then
			return resolveRefreshedProductInfo(
				p4.catalogItemDetails,
				p4.resellersData,
				collectibleItemInstanceId,
				data.timedOptionDays
			)
		end

		return resolveRefreshedExpectedPrice(
			p4.catalogItemDetails,
			p4.resellersData,
			collectibleItemInstanceId,
			data.timedOptionDays
		)
	end)

	return Promise.all({ bundleDetails = v5, refreshedExpectedPrice = v8 }):andThen(function(p4)
		local bundleDetails = p4.bundleDetails

		if FFlagFixTimedOptionRefresh then
			local refreshedExpectedPrice = p4.refreshedExpectedPrice

			if refreshedExpectedPrice ~= nil then
				for k, v9 in pairs(refreshedExpectedPrice) do
					bundleDetails[k] = v9
				end

				return bundleDetails
			end
		else
			bundleDetails.refreshedExpectedPrice = p4.refreshedExpectedPrice
		end

		return bundleDetails
	end)
end

return getBundleDetails
