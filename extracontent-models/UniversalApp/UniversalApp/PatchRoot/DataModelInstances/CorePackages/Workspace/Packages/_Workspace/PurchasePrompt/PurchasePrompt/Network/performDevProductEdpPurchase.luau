local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

game:GetService("HttpService")

local PurchasePromptParent = PurchasePrompt.Parent
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Http = require(PurchasePromptParent.Http)
local ArgCheck = require(PurchasePromptParent.ArgCheck)
local Promise = require(PurchasePrompt.Promise)
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local Logging = require(PurchasePromptParent.AppCommonLib).Logging
local _ = Http.Url
local _ = Http.PerformFetch
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
local parseDevProductPurchaseError = require(PurchasePrompt.Utils.parseDevProductPurchaseError)
local FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase = require(PurchasePromptParent.SharedFlags).FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase

require(PurchasePrompt.types)

local t1 = {
	new = function() -- line: 32
		return {
			price = 0,
			productId = 0,
			purchased = false,
			receipt = "",
			success = false,
			transactionStatus = ""
		}
	end
}

function t1.fromJsonData(p1) -- line: 43
	-- upvalues: t1 (copy), ArgCheck (copy)
	local v17 = t1.new()

	ArgCheck.isType(p1, "table", "PurchaseDeveloperProductModel.fromJsonData's jsonData")
	ArgCheck.isType(p1.price, "number", "PurchaseDeveloperProductModel.fromJsonData's jsonData.price")
	ArgCheck.isType(p1.productId, "number", "PurchaseDeveloperProductModel.fromJsonData's jsonData.productId")
	ArgCheck.isType(p1.purchased, "boolean", "PurchaseDeveloperProductModel.fromJsonData's jsonData.purchased")
	ArgCheck.isTypeOrNil(p1.receipt, "string", "PurchaseDeveloperProductModel.fromJsonData's jsonData.receipt")
	ArgCheck.isTypeOrNil(p1.success, "boolean", "PurchaseDeveloperProductModel.fromJsonData's jsonData.success")
	ArgCheck.isTypeOrNil(p1.transactionStatus, "string", "PurchaseDeveloperProductModel.fromJsonData's jsonData.transactionStatus")
	v17.price = p1.price
	v17.productId = p1.productId
	v17.purchased = p1.purchased == true
	v17.receipt = p1.receipt
	v17.success = p1.success == true
	v17.transactionStatus = p1.transactionStatus

	return v17
end

local function performDevProductEdpPurchase(p2, n1: number, p3) -- line: 68
	-- upvalues: Logging (copy), Promise (copy), PurchaseError (copy), isEconomicRestrictionResponse (copy), FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase (copy), parseDevProductPurchaseError (copy), t1 (copy)
	return p2.performDevProductEdpPurchase(n1, p3):andThen(function(p4) -- line: 69
		-- upvalues: Logging (copy), Promise (copy), PurchaseError (copy), isEconomicRestrictionResponse (copy), FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase (copy), parseDevProductPurchaseError (copy), t1 (copy)
		if type(p4) ~= "table" then
			Logging.warn("Response from PurchaseDeveloperProduct is malformed!")

			return Promise.reject(PurchaseError.UnknownFailure)
		end

		if isEconomicRestrictionResponse(p4) then
			return Promise.reject(p4)
		end

		if FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase then
			local v22 = parseDevProductPurchaseError(p4)

			if v22 == PurchaseError.PendingProductsLimitExceeded then
				return Promise.reject(v22)
			end
		end

		local v23 = t1.fromJsonData(p4)

		if v23.purchased then
			return Promise.resolve(v23)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p5) -- line: 94
		-- upvalues: Promise (copy)
		return Promise.reject(p5)
	end)
end

return performDevProductEdpPurchase
