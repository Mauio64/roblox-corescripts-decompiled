local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local Promise = require(BulkPurchaseAppParent.Promise)
local BulkPurchaseRequested = require(BulkPurchaseApp.Store.Actions.BulkPurchaseRequested)
local BulkPurchaseFailed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseFailed)
local BulkPurchaseStarted = require(BulkPurchaseApp.Store.Actions.BulkPurchaseStarted)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)
local getAccount = require(BulkPurchaseApp.NetworkRequests.getAccount)

require(BulkPurchaseApp.Store.Types)

local function InitiateBulkPurchaseFlow(p1, t1: {[any]: any}, p2, n1: number, n2: number, p3, p4) -- line: 17
	-- upvalues: BulkPurchaseRequested (copy), getAccount (copy), Promise (copy), BulkPurchaseStarted (copy), BulkPurchaseFailed (copy), ErrorCodeEnum (copy)
	return function(p5) -- line: 26
		-- upvalues: BulkPurchaseRequested (copy), t1 (copy), p2 (copy), n1 (copy), n2 (copy), p3 (copy), p4 (copy), getAccount (copy), p1 (copy), Promise (copy), BulkPurchaseStarted (copy), BulkPurchaseFailed (copy), ErrorCodeEnum (copy)
		p5:dispatch(BulkPurchaseRequested(t1, p2, n1, n2, p3, p4))

		local v18, _ = getAccount(p1)

		return Promise.all({ v18 }):andThen(function(_) -- line: 41
			-- upvalues: p5 (copy), BulkPurchaseStarted (copy), n1 (copy)
			p5:dispatch(BulkPurchaseStarted(n1))
		end):catch(function(_) -- line: 49
			-- upvalues: p5 (copy), BulkPurchaseFailed (copy), ErrorCodeEnum (copy)
			p5:dispatch(BulkPurchaseFailed(ErrorCodeEnum.Generic))
		end)
	end
end

return InitiateBulkPurchaseFlow
