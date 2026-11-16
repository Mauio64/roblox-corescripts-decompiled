local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
game:GetService("HttpService")
local parent = PurchasePrompt.Parent

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Http = require(parent.Http)
local ArgCheck = require(parent.ArgCheck)
local Promise = require(PurchasePrompt.Promise)
local IAPExperience = require(parent.IAPExperience)
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging

local Url = Http.Url
local PerformFetch = Http.PerformFetch
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
local parseDevProductPurchaseError = require(PurchasePrompt.Utils.parseDevProductPurchaseError)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase = SharedFlags.FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase
require(PurchasePrompt.types)

local v = {}

function v.new()
	return {
		price = 0,
		productId = 0,
		purchased = false,
		receipt = "",
		success = false,
		transactionStatus = ""
	}
end

function v.fromJsonData(data)
	local v2 = v.new()

	ArgCheck.isType(data, "table", "PurchaseDeveloperProductModel.fromJsonData's jsonData")
	ArgCheck.isType(data.price, "number", "PurchaseDeveloperProductModel.fromJsonData's jsonData.price")
	ArgCheck.isType(data.productId, "number", "PurchaseDeveloperProductModel.fromJsonData's jsonData.productId")
	ArgCheck.isType(data.purchased, "boolean", "PurchaseDeveloperProductModel.fromJsonData's jsonData.purchased")
	ArgCheck.isTypeOrNil(data.receipt, "string", "PurchaseDeveloperProductModel.fromJsonData's jsonData.receipt")
	ArgCheck.isTypeOrNil(data.success, "boolean", "PurchaseDeveloperProductModel.fromJsonData's jsonData.success")
	ArgCheck.isTypeOrNil(
		data.transactionStatus,
		"string",
		"PurchaseDeveloperProductModel.fromJsonData's jsonData.transactionStatus"
	)

	v2.price = data.price
	v2.productId = data.productId
	v2.purchased = data.purchased == true
	v2.receipt = data.receipt
	v2.success = data.success == true
	v2.transactionStatus = data.transactionStatus

	return v2
end

local function performDevProductEdpPurchase(p, p2: number, p3)
	return p.performDevProductEdpPurchase(p2, p3):andThen(function(p4)
		if type(p4) ~= "table" then
			Logging.warn("Response from PurchaseDeveloperProduct is malformed!")
			return Promise.reject(PurchaseError.UnknownFailure)
		end

		if isEconomicRestrictionResponse(p4) then
			return Promise.reject(p4)
		end

		if FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase then
			local v2 = parseDevProductPurchaseError(p4)

			if v2 == PurchaseError.PendingProductsLimitExceeded then
				return Promise.reject(v2)
			end
		end

		local v2 = v.fromJsonData(p4)

		if v2.purchased then
			return Promise.resolve(v2)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p4)
		return Promise.reject(p4)
	end)
end

return performDevProductEdpPurchase
