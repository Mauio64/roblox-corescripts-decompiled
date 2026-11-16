local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PaymentPlatform")
local paymentPlatformToUpsellPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/paymentPlatformToUpsellPlatform")

local getUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").IAPExperience.Api.PaymentsGateway.GetUpsellSuggestions

local upsellSuggestionsAPIMaxPackages = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").UpsellSuggestionsAPIMaxPackages

return function(p2, p3, p4, p5, p6, p7, p8, p9)
	local v5 = paymentPlatformToUpsellPlatform(p4)

	return (Promise.new(function(callback, callback2)
		spawn(function()
			local upsellSuggestions, v6 = getUpsellSuggestions(
				v5,
				p3,
				p2,
				upsellSuggestionsAPIMaxPackages,
				p6,
				p7,
				p8,
				p9,
				p5
			)

			if not upsellSuggestions then
				return callback2(PurchaseError.UnknownFailure)
			end

			if v6 and v6.products and #v6.products ~= 0 then
				return callback(v6)
			end

			return callback2(PurchaseError.UnknownFailure)
		end)
	end))
end
