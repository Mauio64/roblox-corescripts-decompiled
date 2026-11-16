local parent = script.Parent.Parent

local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)
require(parent.Parent.LuauPolyfill)

local FFlagRefreshPriceOnRetryAfterUpsell = require(parent.Flags.FFlagRefreshPriceOnRetryAfterUpsell)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagEnableFetchCartPricingDuringInExperience = SharedFlags.FFlagEnableFetchCartPricingDuringInExperience
local getCatalogItemDetails = require(parent.Network.getCatalogItemDetails)
local getResellers = require(parent.Network.getResellers)
local resolveRefreshedExpectedPrice = require(parent.Utils.resolveRefreshedExpectedPrice)
local FFlagFixTimedOptionRefresh = require(parent.Flags.FFlagFixTimedOptionRefresh)
local resolveRefreshedProductInfo = require(parent.Utils.resolveRefreshedProductInfo)

local function convertDiscountInfoToPriceDiscountDetails(discountInformation)
	if not discountInformation or type(discountInformation.discounts) ~= "table" then
		return nil
	end

	local result = {}

	for _, discount in ipairs(discountInformation.discounts) do
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
		local userBasePriceInRobux = state.BasePriceInRobux

		if not userBasePriceInRobux then
			local v

			if discountInformation then
				v = discountInformation.originalPrice
			end

			userBasePriceInRobux = v or state.PriceInRobux

			if not userBasePriceInRobux then
				local v2

				if state.product then
					v2 = state.product.priceInRobux
				end

				userBasePriceInRobux = v2 or 0
			end
		end

		state.UserBasePriceInRobux = userBasePriceInRobux
	end

	if not state.PriceDiscountDetails and state.discountInformation then
		state.PriceDiscountDetails = convertDiscountInfoToPriceDiscountDetails(state.discountInformation)
	end

	return state
end

local function getBundleDetails(p, p2, data, callback)
	local bundleDetails2 = p.getBundleDetails(p2):andThen(function(p3)
		if
			FFlagEnableFetchCartPricingDuringInExperience
			and p3.collectibleItemDetail
			and p3.collectibleItemDetail.collectibleItemId
			and callback
		then
			return callback(p3.collectibleItemDetail.collectibleItemId):andThen(function()
				return normalizeBundleFields(p3)
			end):catch(function()
				return normalizeBundleFields(p3)
			end)
		end

		return Promise.resolve(normalizeBundleFields(p3))
	end):catch(function(_)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)

	if not (FFlagRefreshPriceOnRetryAfterUpsell and data) then
		return bundleDetails2
	end

	local collectibleItemId = data.collectibleItemId
	local collectibleItemInstanceId = data.collectibleItemInstanceId

	local all = Promise.all
	local v = {
		catalogItemDetails = getCatalogItemDetails(p, p2, "bundle"):catch(function(): nil
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
		resellersData = getResellers(p, collectibleItemId, 10):catch(function(): nil
			return nil
		end)
	else
		resellersData = Promise.resolve(nil)
	end

	v.resellersData = resellersData
	local refreshedExpectedPrice2 = all(v):andThen(function(p3)
		if FFlagFixTimedOptionRefresh then
			return resolveRefreshedProductInfo(
				p3.catalogItemDetails,
				p3.resellersData,
				collectibleItemInstanceId,
				data.timedOptionDays
			)
		end

		return (resolveRefreshedExpectedPrice(
			p3.catalogItemDetails,
			p3.resellersData,
			collectibleItemInstanceId,
			data.timedOptionDays
		))
	end)

	return Promise.all({
		bundleDetails = bundleDetails2,
		refreshedExpectedPrice = refreshedExpectedPrice2
	}):andThen(function(p3)
		local bundleDetails = p3.bundleDetails

		if FFlagFixTimedOptionRefresh then
			local refreshedExpectedPrice = p3.refreshedExpectedPrice

			if refreshedExpectedPrice ~= nil then
				for k, v2 in pairs(refreshedExpectedPrice) do
					bundleDetails[k] = v2
				end

				return bundleDetails
			end
		else
			bundleDetails.refreshedExpectedPrice = p3.refreshedExpectedPrice
		end

		return bundleDetails
	end)
end

return getBundleDetails
