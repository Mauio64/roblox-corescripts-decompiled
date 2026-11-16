local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local Promise = require(parent.Promise)
local getBalanceRequest = require(CurrencyTransfers.NetworkRequests.getBalanceRequest)

local function getBalanceAfterPurchaseWebview(p, p2)
	local v = (not p or p.refetchDelaySeconds == nil) and 0.45 or p.refetchDelaySeconds

	return getBalanceRequest(nil, p2):andThen(function(p3: number)
		if v <= 0 then
			return p3
		end

		return Promise.delay(v):andThen(function()
			return getBalanceRequest(nil, p2):andThen(function(p4: number)
				return (math.max(p3, p4))
			end):catch(function()
				return p3
			end)
		end)
	end)
end

return getBalanceAfterPurchaseWebview
