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

require(PurchasePrompt.types)

local t1 = {}
local _ = {
	InsufficientFunds = "InsufficientFunds"
}

function t1.new() -- line: 34
	return {
		purchased = false,
		productId = 0,
		reason = "",
		title = "",
		showDivId = "",
		shortfallPrice = 0,
		statusCode = 0
	}
end
function t1.fromJsonData(p1) -- line: 46
	-- upvalues: t1 (copy), ArgCheck (copy)
	local v16 = t1.new()

	ArgCheck.isType(p1, "table", "PurchaseExperienceProduct.fromJsonData's jsonData")
	ArgCheck.isType(p1.purchased, "boolean", "PurchaseExperienceProduct.fromJsonData's jsonData.purchased")
	ArgCheck.isType(p1.productId, "number", "PurchaseExperienceProduct.fromJsonData's jsonData.productId")
	ArgCheck.isTypeOrNil(p1.reason, "string", "PurchaseExperienceProduct.fromJsonData's jsonData.reason")
	ArgCheck.isTypeOrNil(p1.title, "string", "PurchaseProduct.fromJsonData's jsonData.title")
	ArgCheck.isTypeOrNil(p1.showDivId, "string", "PurchaseProduct.fromJsonData's jsonData.showDivId")
	ArgCheck.isTypeOrNil(p1.shortfallPrice, "number", "PurchaseProduct.fromJsonData's jsonData.shortfallPrice")
	ArgCheck.isTypeOrNil(p1.statusCode, "number", "PurchaseProduct.fromJsonData's jsonData.statusCode")
	v16.purchased = p1.purchased == true
	v16.productId = tonumber(p1.productId)
	v16.reason = p1.reason
	v16.title = p1.title
	v16.showDivId = p1.showDivId
	v16.shortfallPrice = p1.shortfallPrice
	v16.statusCode = p1.statusCode

	return v16
end

local function performExperiencePurchase(p2, n1: number, p3) -- line: 69
	-- upvalues: Logging (copy), Promise (copy), PurchaseError (copy), isEconomicRestrictionResponse (copy), t1 (copy)
	return p2.performExperiencePurchase(n1, p3):andThen(function(p4) -- line: 70
		-- upvalues: Logging (copy), Promise (copy), PurchaseError (copy), isEconomicRestrictionResponse (copy), t1 (copy)
		if type(p4) ~= "table" then
			Logging.warn("Response from performExperiencePurchase is malformed!")

			return Promise.reject(PurchaseError.UnknownFailure)
		end

		if isEconomicRestrictionResponse(p4) then
			return Promise.reject(p4)
		end

		local v21 = t1.fromJsonData(p4)

		if v21.purchased then
			return Promise.resolve(v21)
		end

		if v21.reason and v21.reason == "InsufficientFunds" then
			return Promise.reject(PurchaseError.NotEnoughRobux)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p5) -- line: 93
		-- upvalues: Promise (copy)
		return Promise.reject(p5)
	end)
end

return performExperiencePurchase
