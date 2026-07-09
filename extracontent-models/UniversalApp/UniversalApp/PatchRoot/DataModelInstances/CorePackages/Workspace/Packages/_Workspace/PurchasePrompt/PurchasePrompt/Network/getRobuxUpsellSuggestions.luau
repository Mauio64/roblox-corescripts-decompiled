local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Promise = require(PurchasePrompt.Promise)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)

require(PurchasePrompt.Enums.PaymentPlatform)

local paymentPlatformToUpsellPlatform = require(PurchasePrompt.Utils.paymentPlatformToUpsellPlatform)

game:GetService("HttpService")

local GetUpsellSuggestions = require(PurchasePromptParent.PurchasePromptDeps).IAPExperience.Api.PaymentsGateway.GetUpsellSuggestions
local UpsellSuggestionsAPIMaxPackages = require(PurchasePromptParent.SharedFlags).UpsellSuggestionsAPIMaxPackages

return function(n1: number, n2: number, s1: string, n3: number?, s2: string?, n4: number?, s3: string?) -- line: 15
	-- upvalues: paymentPlatformToUpsellPlatform (copy), Promise (copy), GetUpsellSuggestions (copy), UpsellSuggestionsAPIMaxPackages (copy), PurchaseError (copy)
	local v15 = paymentPlatformToUpsellPlatform(s1)

	return (Promise.new(function(resolve, reject) -- line: 27
		-- upvalues: GetUpsellSuggestions (copy), v15 (copy), n2 (copy), n1 (copy), UpsellSuggestionsAPIMaxPackages (copy), n3 (copy), s2 (copy), n4 (copy), s3 (copy), PurchaseError (copy)
		spawn(function() -- line: 29
			-- upvalues: GetUpsellSuggestions (copy), v15 (copy), n2 (copy), n1 (copy), UpsellSuggestionsAPIMaxPackages (copy), n3 (copy), s2 (copy), n4 (copy), s3 (copy), reject (copy), PurchaseError (copy), resolve (copy)
			local v18, v19 = GetUpsellSuggestions(v15, n2, n1, UpsellSuggestionsAPIMaxPackages, n3, s2, n4, s3)

			if not v18 then
				return reject(PurchaseError.UnknownFailure)
			end

			if not v19 or not v19.products or #v19.products == 0 then
				return reject(PurchaseError.UnknownFailure)
			end

			return resolve(v19)
		end)
	end))
end
