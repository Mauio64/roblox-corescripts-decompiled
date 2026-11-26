local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local fFlagAddPurchaseOptionForProvidingBalance = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAddPurchaseOptionForProvidingBalance

local function getBalanceInfo(p2, p3, p4, p5, p6)
	if fFlagAddPurchaseOptionForProvidingBalance and p6 ~= nil then
		return Promise.resolve({ robux = p6, hasFailed = false })
	end

	return p2.getBalanceInfo():andThen(function(p7)
		if p3.isStudio() and not p4 then
			p7.robux = 2147483647
		end

		p7.hasFailed = false
		return Promise.resolve(p7)
	end):catch(function(p7)
		if p5 then
			return Promise.resolve({ robux = 0, hasFailed = true })
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getBalanceInfo
