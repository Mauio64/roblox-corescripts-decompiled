local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)
local FFlagAddPurchaseOptionForProvidingBalance = require(ParentParent.Parent.SharedFlags).FFlagAddPurchaseOptionForProvidingBalance

local function getBalanceInfo(p1, p2, p3, b1: boolean?, n1: number?) -- line: 10
	-- upvalues: FFlagAddPurchaseOptionForProvidingBalance (copy), Promise (copy), PurchaseError (copy)
	if FFlagAddPurchaseOptionForProvidingBalance and n1 ~= nil then
		return Promise.resolve({
			hasFailed = false,
			robux = n1
		})
	end

	return p1.getBalanceInfo():andThen(function(p4) -- line: 22
		-- upvalues: p2 (copy), p3 (copy), Promise (copy)
		if p2.isStudio() and not p3 then
			p4.robux = 2147483647
		end

		p4.hasFailed = false

		return Promise.resolve(p4)
	end):catch(function(_) -- line: 33
		-- upvalues: b1 (copy), Promise (copy), PurchaseError (copy)
		if b1 then
			return Promise.resolve({
				robux = 0,
				hasFailed = true
			})
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getBalanceInfo
