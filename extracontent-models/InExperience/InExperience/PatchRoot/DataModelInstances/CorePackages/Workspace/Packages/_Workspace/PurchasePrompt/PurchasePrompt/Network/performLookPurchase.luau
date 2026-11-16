local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Http = require(parent.Http)
local Promise = require(PurchasePrompt.Promise)
require(PurchasePrompt.Enums.ItemType)
local IAPExperience = require(parent.IAPExperience)
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging

local PerformFetch = Http.PerformFetch
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
require(PurchasePrompt.types)
require(parent.AvatarExperienceCommon.PurchaseItemsTypes)
local Constants = require(PurchasePrompt.Misc.Constants)

local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)

local _ = {
	Unspecified = "Unspecified",
	Success = "Success",
	Failure = "Failure",
	PartialSuccess = "PartialSuccess"
}

if not SharedFlags.FFlagPurchasePromptFetchCartPricingForLooks then
	local function performLookPurchase(p, p2: string, p3)
		return p.performLookPurchase(p2, p3):andThen(function(p4)
			if type(p4) ~= "table" then
				Logging.warn("Response from performLookPurchase is malformed!")
				return Promise.reject(PurchaseError.UnknownFailure)
			end

			if isEconomicRestrictionResponse(p4) then
				return Promise.reject(p4)
			end

			if p4.purchaseLookStatus == "Success" or p4.purchaseLookStatus == "PartialSuccess" then
				return Promise.resolve(p4)
			end

			return Promise.reject(PurchaseError.UnknownFailure)
		end, function(p4)
			return Promise.reject(p4)
		end)
	end

	return performLookPurchase
end

local function toLegacyLookPurchaseResult(p, p2)
	local count = 0
	local assetPurchaseStatus = {}
	local bundlePurchaseStatus = {}
	local count2 = 0

	for _, v in ipairs(p.fulfillmentGroups or {}) do
		for _, v2 in ipairs(v.lineItems or {}) do
			local v3 = p2[v2.collectibleProductId]

			if v3 == nil then
				continue
			end

			local v4 = v2.status == "SUCCEEDED" and "Success" or "Failure"

			count += 1

			if v4 == "Success" then
				count2 += 1
			end

			if v3.itemType == Constants.ProductType.Asset then
				assetPurchaseStatus[v3.itemId] = v4
			else
				bundlePurchaseStatus[v3.itemId] = v4
			end
		end
	end

	return {
		purchaseLookStatus = count > 0 and count2 == count and "Success" or count2 > 0 and "PartialSuccess" or "Failure",
		assetPurchaseStatus = assetPurchaseStatus,
		bundlePurchaseStatus = bundlePurchaseStatus
	}
end

local function performLookPurchase(p, p2: string, p3)
	local v = {}
	local v2 = {}

	for _, v3 in ipairs(p3.bulkPurchaseLineItems or {}) do
		v[v3.collectibleProductId] = v3
		table.insert(v2, {
			collectibleProductId = v3.collectibleProductId,
			collectibleItemId = v3.collectibleItemId,
			agreedPriceRobux = v3.agreedPriceRobux,
			rentalOption = v3.rentalDays and v3.rentalDays > 0 and { durationDays = v3.rentalDays } or nil,
			offerIds = v3.offerIds
		})
	end

	if #v2 == 0 then
		return Promise.reject(PurchaseError.UnknownFailure)
	end

	return p.performLookPurchaseBulkPurchase(p2, p3.idempotencyKey, v2):andThen(function(p4)
		if type(p4) ~= "table" then
			Logging.warn("Response from performLookPurchase is malformed!")
			return Promise.reject(PurchaseError.UnknownFailure)
		end

		if isEconomicRestrictionResponse(p4) then
			return Promise.reject(p4)
		end

		local v3 = toLegacyLookPurchaseResult(p4, v)

		if v3.purchaseLookStatus == "Success" or v3.purchaseLookStatus == "PartialSuccess" then
			return Promise.resolve(v3)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p4)
		return Promise.reject(p4)
	end)
end

return performLookPurchase
