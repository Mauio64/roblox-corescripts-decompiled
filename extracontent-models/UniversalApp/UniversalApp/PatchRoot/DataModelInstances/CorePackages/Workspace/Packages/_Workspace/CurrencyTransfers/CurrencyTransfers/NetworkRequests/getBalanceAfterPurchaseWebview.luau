local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local Promise = require(CurrencyTransfersParent.Promise)
local getBalanceRequest = require(CurrencyTransfers.NetworkRequests.getBalanceRequest)

local function getBalanceAfterPurchaseWebview(t1: {[any]: any}?) -- line: 15
	-- upvalues: getBalanceRequest (copy), Promise (copy)
	local v7 = (not t1 or t1.refetchDelaySeconds == nil) and 0.45 or t1.refetchDelaySeconds

	return getBalanceRequest():andThen(function(n1: number) -- line: 20
		-- upvalues: v7 (copy), Promise (copy), getBalanceRequest (copy)
		if v7 <= 0 then
			return n1
		end

		return Promise.delay(v7):andThen(function() -- line: 24
			-- upvalues: getBalanceRequest (copy), n1 (copy)
			return getBalanceRequest():andThen(function(n2: number) -- line: 26
				-- upvalues: n1 (copy)
				return (math.max(n1, n2))
			end):catch(function() -- line: 29
				-- upvalues: n1 (copy)
				return n1
			end)
		end)
	end)
end

return getBalanceAfterPurchaseWebview
