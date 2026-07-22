local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local Promise = require(CurrencyTransfersParent.Promise)
local getBalanceRequest = require(CurrencyTransfers.NetworkRequests.getBalanceRequest)

local function getBalanceAfterPurchaseWebview(t1: {[any]: any}?, p1) -- line: 17
	-- upvalues: getBalanceRequest (copy), Promise (copy)
	local v8 = (not t1 or t1.refetchDelaySeconds == nil) and 0.45 or t1.refetchDelaySeconds

	return getBalanceRequest(nil, p1):andThen(function(n1: number) -- line: 22
		-- upvalues: v8 (copy), Promise (copy), getBalanceRequest (copy), p1 (copy)
		if v8 <= 0 then
			return n1
		end

		return Promise.delay(v8):andThen(function() -- line: 26
			-- upvalues: getBalanceRequest (copy), p1 (copy), n1 (copy)
			return getBalanceRequest(nil, p1):andThen(function(n2: number) -- line: 28
				-- upvalues: n1 (copy)
				return (math.max(n1, n2))
			end):catch(function() -- line: 31
				-- upvalues: n1 (copy)
				return n1
			end)
		end)
	end)
end

return getBalanceAfterPurchaseWebview
