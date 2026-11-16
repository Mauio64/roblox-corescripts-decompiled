local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Promise = require(PurchasePrompt.Promise)

local parseSubscriptionError = require(PurchasePrompt.Utils.parseSubscriptionError)

local function performDeveloperSubscriptionRobuxPurchase(p, p2: string, p3: number)
	return p.performDeveloperSubscriptionRobuxPurchase(p2, p3):andThen(function()
		return Promise.resolve()
	end, function(value)
		if type(value) == "string" then
			return Promise.reject(parseSubscriptionError(value))
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performDeveloperSubscriptionRobuxPurchase
