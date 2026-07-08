local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

game:GetService("HttpService")

local PurchasePromptParent = PurchasePrompt.Parent
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Http = require(PurchasePromptParent.Http)

require(PurchasePromptParent.ArgCheck)

local Promise = require(PurchasePrompt.Promise)
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local Logging = require(PurchasePromptParent.AppCommonLib).Logging
local _ = Http.Url
local _ = Http.PerformFetch
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse

require(PurchasePrompt.types)

local _ = {
	Unspecified = "Unspecified",
	Success = "Success",
	Failure = "Failure",
	PartialSuccess = "PartialSuccess"
}

local function performLookPurchase(p1, s1: string, p2) -- line: 24
	-- upvalues: Logging (copy), Promise (copy), PurchaseError (copy), isEconomicRestrictionResponse (copy)
	return p1.performLookPurchase(s1, p2):andThen(function(p3) -- line: 25
		-- upvalues: Logging (copy), Promise (copy), PurchaseError (copy), isEconomicRestrictionResponse (copy)
		if type(p3) ~= "table" then
			Logging.warn("Response from performLookPurchase is malformed!")

			return Promise.reject(PurchaseError.UnknownFailure)
		end

		if isEconomicRestrictionResponse(p3) then
			return Promise.reject(p3)
		end

		if p3.purchaseLookStatus == "Success" or p3.purchaseLookStatus == "PartialSuccess" then
			return Promise.resolve(p3)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p4) -- line: 43
		-- upvalues: Promise (copy)
		return Promise.reject(p4)
	end)
end

return performLookPurchase
