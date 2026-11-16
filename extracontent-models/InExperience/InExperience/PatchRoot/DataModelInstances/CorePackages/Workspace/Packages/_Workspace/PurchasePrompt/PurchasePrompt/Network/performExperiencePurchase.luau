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
require(PurchasePrompt.types)

local v = {}

local _ = { InsufficientFunds = "InsufficientFunds" }

function v.new()
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

function v.fromJsonData(data)
	local v2 = v.new()

	ArgCheck.isType(data, "table", "PurchaseExperienceProduct.fromJsonData's jsonData")
	ArgCheck.isType(data.purchased, "boolean", "PurchaseExperienceProduct.fromJsonData's jsonData.purchased")
	ArgCheck.isType(data.productId, "number", "PurchaseExperienceProduct.fromJsonData's jsonData.productId")
	ArgCheck.isTypeOrNil(data.reason, "string", "PurchaseExperienceProduct.fromJsonData's jsonData.reason")
	ArgCheck.isTypeOrNil(data.title, "string", "PurchaseProduct.fromJsonData's jsonData.title")
	ArgCheck.isTypeOrNil(data.showDivId, "string", "PurchaseProduct.fromJsonData's jsonData.showDivId")
	ArgCheck.isTypeOrNil(data.shortfallPrice, "number", "PurchaseProduct.fromJsonData's jsonData.shortfallPrice")
	ArgCheck.isTypeOrNil(data.statusCode, "number", "PurchaseProduct.fromJsonData's jsonData.statusCode")

	v2.purchased = data.purchased == true
	v2.productId = tonumber(data.productId)
	v2.reason = data.reason
	v2.title = data.title
	v2.showDivId = data.showDivId
	v2.shortfallPrice = data.shortfallPrice
	v2.statusCode = data.statusCode

	return v2
end

local function performExperiencePurchase(p, p2: number, p3)
	return p.performExperiencePurchase(p2, p3):andThen(function(p4)
		if type(p4) ~= "table" then
			Logging.warn("Response from performExperiencePurchase is malformed!")
			return Promise.reject(PurchaseError.UnknownFailure)
		end

		if isEconomicRestrictionResponse(p4) then
			return Promise.reject(p4)
		end

		local v2 = v.fromJsonData(p4)

		if v2.purchased then
			return Promise.resolve(v2)
		end

		if v2.reason and v2.reason == "InsufficientFunds" then
			return Promise.reject(PurchaseError.NotEnoughRobux)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p4)
		return Promise.reject(p4)
	end)
end

return performExperiencePurchase
