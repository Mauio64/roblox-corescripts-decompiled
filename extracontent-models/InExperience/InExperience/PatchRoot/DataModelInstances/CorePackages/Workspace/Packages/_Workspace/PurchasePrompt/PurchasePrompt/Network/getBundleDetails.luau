local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)
local FFlagRefreshPriceOnRetryAfterUpsell = require(ParentParent.Flags.FFlagRefreshPriceOnRetryAfterUpsell)
local FFlagEnableDiscountInfoInUnifiedPurchaseModal = require(ParentParent.Parent.SharedFlags).FFlagEnableDiscountInfoInUnifiedPurchaseModal
local getCatalogItemDetails = require(ParentParent.Network.getCatalogItemDetails)
local getResellers = require(ParentParent.Network.getResellers)
local resolveRefreshedExpectedPrice = require(ParentParent.Utils.resolveRefreshedExpectedPrice)
local FFlagFixTimedOptionRefresh = require(ParentParent.Flags.FFlagFixTimedOptionRefresh)
local resolveRefreshedProductInfo = require(ParentParent.Utils.resolveRefreshedProductInfo)

local function convertDiscountInfoToPriceDiscountDetails(p1) -- line: 21
	if not p1 or type(p1.discounts) ~= "table" then
		return nil
	end

	local t1 = {}

	for _, v in ipairs(p1.discounts) do
		table.insert(t1, {
			Type = v.discountCampaign,
			AmountInRobux = v.robuxDiscountAmount,
			Percent = v.robuxDiscountPercentage
		})
	end

	return t1
end
local function normalizeBundleFields(p2) -- line: 36
	-- upvalues: FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), convertDiscountInfoToPriceDiscountDetails (copy)
	if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then
		return p2
	end

	if not p2.UserBasePriceInRobux then
		local discountInformation = p2.discountInformation

		p2.UserBasePriceInRobux = p2.BasePriceInRobux or (((if not discountInformation then nil else discountInformation.originalPrice)) or (p2.PriceInRobux or (((if not p2.product then nil else p2.product.priceInRobux)) or 0)))
	end

	if not p2.PriceDiscountDetails and p2.discountInformation then
		p2.PriceDiscountDetails = convertDiscountInfoToPriceDiscountDetails(p2.discountInformation)
	end

	return p2
end
local function getBundleDetails(p3, p4, t2: {[any]: any}?) -- line: 57
	-- upvalues: Promise (copy), normalizeBundleFields (copy), PurchaseError (copy), FFlagRefreshPriceOnRetryAfterUpsell (copy), getCatalogItemDetails (copy), getResellers (copy), FFlagFixTimedOptionRefresh (copy), resolveRefreshedProductInfo (copy), resolveRefreshedExpectedPrice (copy)
	local v23 = p3.getBundleDetails(p4):andThen(function(p5) -- line: 60
		-- upvalues: Promise (copy), normalizeBundleFields (copy)
		return Promise.resolve((normalizeBundleFields(p5)))
	end):catch(function(_) -- line: 63
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)

	if not FFlagRefreshPriceOnRetryAfterUpsell or not t2 then
		return v23
	end

	local collectibleItemId = t2.collectibleItemId
	local collectibleItemInstanceId = t2.collectibleItemInstanceId
	local v26 = Promise.all({
		catalogItemDetails = getCatalogItemDetails(p3, p4, "bundle"):catch(function() -- line: 76
			return nil
		end),
		resellersData = if not collectibleItemInstanceId or (collectibleItemInstanceId == "" or (not collectibleItemId or collectibleItemId == "")) then Promise.resolve(nil) else getResellers(p3, collectibleItemId, 10):catch(function() -- line: 83
			return nil
		end)
	}):andThen(function(p7) -- line: 87
		-- upvalues: FFlagFixTimedOptionRefresh (copy), resolveRefreshedProductInfo (copy), collectibleItemInstanceId (copy), t2 (copy), resolveRefreshedExpectedPrice (copy)
		if FFlagFixTimedOptionRefresh then
			return resolveRefreshedProductInfo(p7.catalogItemDetails, p7.resellersData, collectibleItemInstanceId, t2.timedOptionDays)
		end

		return (resolveRefreshedExpectedPrice(p7.catalogItemDetails, p7.resellersData, collectibleItemInstanceId, t2.timedOptionDays))
	end)

	return Promise.all({
		bundleDetails = v23,
		refreshedExpectedPrice = v26
	}):andThen(function(p8) -- line: 107
		-- upvalues: FFlagFixTimedOptionRefresh (copy)
		local bundleDetails = p8.bundleDetails

		if FFlagFixTimedOptionRefresh then
			local refreshedExpectedPrice = p8.refreshedExpectedPrice

			if refreshedExpectedPrice ~= nil then
				for k, v in pairs(refreshedExpectedPrice) do
					bundleDetails[k] = v
				end

				return bundleDetails
			end
		else
			bundleDetails.refreshedExpectedPrice = p8.refreshedExpectedPrice
		end

		return bundleDetails
	end)
end

return getBundleDetails
