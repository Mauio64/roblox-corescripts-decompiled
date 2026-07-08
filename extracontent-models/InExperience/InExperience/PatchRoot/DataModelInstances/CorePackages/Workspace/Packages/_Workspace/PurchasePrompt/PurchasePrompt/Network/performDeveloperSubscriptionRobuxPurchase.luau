local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local _ = PurchasePrompt.Parent
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Promise = require(PurchasePrompt.Promise)
local parseSubscriptionError = require(PurchasePrompt.Utils.parseSubscriptionError)

local function performDeveloperSubscriptionRobuxPurchase(p1, s1: string, n1: number) -- line: 9
	-- upvalues: Promise (copy), parseSubscriptionError (copy), PurchaseError (copy)
	return p1.performDeveloperSubscriptionRobuxPurchase(s1, n1):andThen(function() -- line: 10
		-- upvalues: Promise (copy)
		return Promise.resolve()
	end, function(p2) -- line: 12
		-- upvalues: Promise (copy), parseSubscriptionError (copy), PurchaseError (copy)
		if type(p2) == "string" then
			return Promise.reject(parseSubscriptionError(p2))
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performDeveloperSubscriptionRobuxPurchase
