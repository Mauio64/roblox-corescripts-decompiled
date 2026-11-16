local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Http")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ArgCheck")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/AppCommonLib").Logging

local url = Http.Url
local performFetch = Http.PerformFetch
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
local parseDevProductPurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/parseDevProductPurchaseError")

local fFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local v5 = {}

function v5.new()
	return {
		price = 0,
		productId = 0,
		purchased = false,
		receipt = "",
		success = false,
		transactionStatus = ""
	}
end

function v5.fromJsonData(data)
	local v6 = v5.new()

	ArgCheck.isType(data, "table", "PurchaseDeveloperProductModel.fromJsonData's jsonData")
	ArgCheck.isType(data.price, "number", "PurchaseDeveloperProductModel.fromJsonData's jsonData.price")
	ArgCheck.isType(
		data.productId,
		"number",
		"PurchaseDeveloperProductModel.fromJsonData's jsonData.productId"
	)
	ArgCheck.isType(
		data.purchased,
		"boolean",
		"PurchaseDeveloperProductModel.fromJsonData's jsonData.purchased"
	)
	ArgCheck.isTypeOrNil(
		data.receipt,
		"string",
		"PurchaseDeveloperProductModel.fromJsonData's jsonData.receipt"
	)
	ArgCheck.isTypeOrNil(
		data.success,
		"boolean",
		"PurchaseDeveloperProductModel.fromJsonData's jsonData.success"
	)
	ArgCheck.isTypeOrNil(
		data.transactionStatus,
		"string",
		"PurchaseDeveloperProductModel.fromJsonData's jsonData.transactionStatus"
	)

	v6.price = data.price
	v6.productId = data.productId
	v6.purchased = data.purchased == true
	v6.receipt = data.receipt
	v6.success = data.success == true
	v6.transactionStatus = data.transactionStatus

	return v6
end

local function performDevProductEdpPurchase(p2, p3, p4)
	return p2.performDevProductEdpPurchase(p3, p4):andThen(function(p5)
		if type(p5) ~= "table" then
			logging.warn("Response from PurchaseDeveloperProduct is malformed!")
			return Promise.reject(PurchaseError.UnknownFailure)
		end

		if isEconomicRestrictionResponse(p5) then
			return Promise.reject(p5)
		end

		if fFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase then
			local v6 = parseDevProductPurchaseError(p5)

			if v6 == PurchaseError.PendingProductsLimitExceeded then
				return Promise.reject(v6)
			end
		end

		local v6 = v5.fromJsonData(p5)

		if v6.purchased then
			return Promise.resolve(v6)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p5)
		return Promise.reject(p5)
	end)
end

return performDevProductEdpPurchase
