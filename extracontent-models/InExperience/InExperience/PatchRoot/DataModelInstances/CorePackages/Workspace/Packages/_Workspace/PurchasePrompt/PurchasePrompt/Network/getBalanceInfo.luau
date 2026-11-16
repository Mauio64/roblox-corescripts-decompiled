local parent = script.Parent.Parent

local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagAddPurchaseOptionForProvidingBalance = SharedFlags.FFlagAddPurchaseOptionForProvidingBalance

local function getBalanceInfo(p, p2, p3, flag: boolean?, robux: number?)
	if FFlagAddPurchaseOptionForProvidingBalance and robux ~= nil then
		return Promise.resolve({ robux = robux, hasFailed = false })
	end

	return p.getBalanceInfo():andThen(function(p4)
		if p2.isStudio() and not p3 then
			p4.robux = 2147483647
		end

		p4.hasFailed = false
		return Promise.resolve(p4)
	end):catch(function(_)
		if flag then
			return Promise.resolve({ robux = 0, hasFailed = true })
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getBalanceInfo
