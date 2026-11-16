local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local Promise = require(parent.Promise)

local BulkPurchaseRequested = require(BulkPurchaseApp.Store.Actions.BulkPurchaseRequested)
local BulkPurchaseFailed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseFailed)
local BulkPurchaseStarted = require(BulkPurchaseApp.Store.Actions.BulkPurchaseStarted)
local BulkPurchaseCountersEnum = require(BulkPurchaseApp.Enums.BulkPurchaseCountersEnum)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)
local getAccount = require(BulkPurchaseApp.NetworkRequests.getAccount)
local reportBulkPurchaseRequestCounters = require(BulkPurchaseApp.Utils.reportBulkPurchaseRequestCounters)
require(BulkPurchaseApp.Store.Types)

local FFlagBulkPurchaseRemoveStartedAction = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseRemoveStartedAction)
local FFlagBulkPurchaseReportCounters = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseReportCounters)
local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)

local function InitiateBulkPurchaseFlow(p, p2, p3, p4: number, p5: number, p6, p7, p8)
	return function(object)
		if FFlagAXAddOffersToBulkPurchase then
			object:dispatch(BulkPurchaseRequested(p2, p3, p4, p5, p6, p7, p8))
		else
			object:dispatch(BulkPurchaseRequested(p2, p3, p4, p5, p6, p7))
		end

		if FFlagBulkPurchaseReportCounters then
			reportBulkPurchaseRequestCounters(BulkPurchaseCountersEnum.BulkPurchaseRequestedCounter)
		end

		if FFlagBulkPurchaseRemoveStartedAction then
			return
		end

		local account, _ = getAccount(p)
		return Promise.all({ account }):andThen(function(_)
			object:dispatch(BulkPurchaseStarted(p4))
		end):catch(function(_)
			object:dispatch(BulkPurchaseFailed(ErrorCodeEnum.Generic))
		end)
	end
end

return InitiateBulkPurchaseFlow
