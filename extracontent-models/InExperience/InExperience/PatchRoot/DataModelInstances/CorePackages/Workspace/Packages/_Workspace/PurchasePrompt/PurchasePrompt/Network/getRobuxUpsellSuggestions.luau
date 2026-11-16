local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local Promise = require(PurchasePrompt.Promise)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
require(PurchasePrompt.Enums.PaymentPlatform)
local paymentPlatformToUpsellPlatform = require(PurchasePrompt.Utils.paymentPlatformToUpsellPlatform)

game:GetService("HttpService")
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local GetUpsellSuggestions = PurchasePromptDeps.IAPExperience.Api.PaymentsGateway.GetUpsellSuggestions

local SharedFlags = require(parent.SharedFlags)
local UpsellSuggestionsAPIMaxPackages = SharedFlags.UpsellSuggestionsAPIMaxPackages

return function(p: number, p2: number, p3: string, flag: boolean, p4: number?, p5: string?, p6: number?, p7: string?)
	local v = paymentPlatformToUpsellPlatform(p3)

	return (Promise.new(function(callback, callback2)
		spawn(function()
			local upsellSuggestions, v2 = GetUpsellSuggestions(
				v,
				p2,
				p,
				UpsellSuggestionsAPIMaxPackages,
				p4,
				p5,
				p6,
				p7,
				flag
			)

			if not upsellSuggestions then
				return callback2(PurchaseError.UnknownFailure)
			end

			if v2 and v2.products and #v2.products ~= 0 then
				return callback(v2)
			end

			return callback2(PurchaseError.UnknownFailure)
		end)
	end))
end
