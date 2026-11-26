local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Http")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ArgCheck")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/AppCommonLib").Logging

local url = Http.Url
local performFetch = Http.PerformFetch
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local v5 = {}

local v6 = { InsufficientFunds = "InsufficientFunds" }

function v5.new()
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

function v5.fromJsonData(data)
	local v7 = v5.new()

	ArgCheck.isType(data, "table", "PurchaseExperienceProduct.fromJsonData's jsonData")
	ArgCheck.isType(data.purchased, "boolean", "PurchaseExperienceProduct.fromJsonData's jsonData.purchased")
	ArgCheck.isType(data.productId, "number", "PurchaseExperienceProduct.fromJsonData's jsonData.productId")
	ArgCheck.isTypeOrNil(data.reason, "string", "PurchaseExperienceProduct.fromJsonData's jsonData.reason")
	ArgCheck.isTypeOrNil(data.title, "string", "PurchaseProduct.fromJsonData's jsonData.title")
	ArgCheck.isTypeOrNil(data.showDivId, "string", "PurchaseProduct.fromJsonData's jsonData.showDivId")
	ArgCheck.isTypeOrNil(
		data.shortfallPrice,
		"number",
		"PurchaseProduct.fromJsonData's jsonData.shortfallPrice"
	)
	ArgCheck.isTypeOrNil(data.statusCode, "number", "PurchaseProduct.fromJsonData's jsonData.statusCode")

	v7.purchased = data.purchased == true
	v7.productId = tonumber(data.productId)
	v7.reason = data.reason
	v7.title = data.title
	v7.showDivId = data.showDivId
	v7.shortfallPrice = data.shortfallPrice
	v7.statusCode = data.statusCode

	return v7
end

local function performExperiencePurchase(p2, p3, p4)
	return p2.performExperiencePurchase(p3, p4):andThen(function(p5)
		if type(p5) ~= "table" then
			logging.warn("Response from performExperiencePurchase is malformed!")
			return Promise.reject(PurchaseError.UnknownFailure)
		end

		if isEconomicRestrictionResponse(p5) then
			return Promise.reject(p5)
		end

		local v7 = v5.fromJsonData(p5)

		if v7.purchased then
			return Promise.resolve(v7)
		end

		if v7.reason and v7.reason == "InsufficientFunds" then
			return Promise.reject(PurchaseError.NotEnoughRobux)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p5)
		return Promise.reject(p5)
	end)
end

return performExperiencePurchase
