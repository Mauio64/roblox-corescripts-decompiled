local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Promise")
local getBalanceRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/getBalanceRequest")

local function getBalanceAfterPurchaseWebview(p2, p3)
	local v5 = (not p2 or p2.refetchDelaySeconds == nil) and 0.45 or p2.refetchDelaySeconds

	return getBalanceRequest(nil, p3):andThen(function(p4)
		if v5 <= 0 then
			return p4
		end

		return Promise.delay(v5):andThen(function()
			return getBalanceRequest(nil, p3):andThen(function(p5)
				return (math.max(p4, p5))
			end):catch(function()
				return p4
			end)
		end)
	end)
end

return getBalanceAfterPurchaseWebview
