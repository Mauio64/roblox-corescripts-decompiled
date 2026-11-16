local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Http")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/ItemType")
local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/AppCommonLib").Logging

local performFetch = Http.PerformFetch
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/AvatarExperienceCommon/PurchaseItemsTypes")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")

local v5 = {
	Unspecified = "Unspecified",
	Success = "Success",
	Failure = "Failure",
	PartialSuccess = "PartialSuccess"
}

if not require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagPurchasePromptFetchCartPricingForLooks then
	local function performLookPurchase(p2, p3, p4)
		return p2.performLookPurchase(p3, p4):andThen(function(p5)
			if type(p5) ~= "table" then
				logging.warn("Response from performLookPurchase is malformed!")
				return Promise.reject(PurchaseError.UnknownFailure)
			end

			if isEconomicRestrictionResponse(p5) then
				return Promise.reject(p5)
			end

			if p5.purchaseLookStatus == "Success" or p5.purchaseLookStatus == "PartialSuccess" then
				return Promise.resolve(p5)
			end

			return Promise.reject(PurchaseError.UnknownFailure)
		end, function(p5)
			return Promise.reject(p5)
		end)
	end

	return performLookPurchase
end

local function toLegacyLookPurchaseResult(p2, p3)
	local count = 0
	local v6 = {}
	local v7 = {}
	local count2 = 0

	for i, v8 in ipairs(p2.fulfillmentGroups or {}) do
		for j, v9 in ipairs(v8.lineItems or {}) do
			local v10 = p3[v9.collectibleProductId]

			if v10 == nil then
				continue
			end

			local v11 = v9.status == "SUCCEEDED" and "Success" or "Failure"

			count += 1

			if v11 == "Success" then
				count2 += 1
			end

			if v10.itemType == Constants.ProductType.Asset then
				v6[v10.itemId] = v11
			else
				v7[v10.itemId] = v11
			end
		end
	end

	return {
		purchaseLookStatus = count > 0 and count2 == count and "Success" or count2 > 0 and "PartialSuccess" or "Failure",
		assetPurchaseStatus = v6,
		bundlePurchaseStatus = v7
	}
end

local function performLookPurchase(p2, p3, p4)
	local v6 = {}
	local v7 = {}

	for i, v8 in ipairs(p4.bulkPurchaseLineItems or {}) do
		v6[v8.collectibleProductId] = v8
		table.insert(v7, {
			collectibleProductId = v8.collectibleProductId,
			collectibleItemId = v8.collectibleItemId,
			agreedPriceRobux = v8.agreedPriceRobux,
			rentalOption = v8.rentalDays and v8.rentalDays > 0 and {
				durationDays = v8.rentalDays
			} or nil,
			offerIds = v8.offerIds
		})
	end

	if #v7 == 0 then
		return Promise.reject(PurchaseError.UnknownFailure)
	end

	return p2.performLookPurchaseBulkPurchase(p3, p4.idempotencyKey, v7):andThen(function(p5)
		if type(p5) ~= "table" then
			logging.warn("Response from performLookPurchase is malformed!")
			return Promise.reject(PurchaseError.UnknownFailure)
		end

		if isEconomicRestrictionResponse(p5) then
			return Promise.reject(p5)
		end

		local v8 = toLegacyLookPurchaseResult(p5, v6)

		if v8.purchaseLookStatus == "Success" or v8.purchaseLookStatus == "PartialSuccess" then
			return Promise.resolve(v8)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p5)
		return Promise.reject(p5)
	end)
end

return performLookPurchase
