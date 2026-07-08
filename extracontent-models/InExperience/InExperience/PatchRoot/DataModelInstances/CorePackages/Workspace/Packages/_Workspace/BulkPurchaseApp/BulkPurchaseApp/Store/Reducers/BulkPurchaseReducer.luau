local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local Rodux = require(BulkPurchaseAppParent.Rodux)
local BulkPurchasePromptStateEnum = require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)
local BulkPurchaseEnded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseEnded)
local BulkPurchaseSucceeded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseSucceeded)
local BulkPurchaseFailed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseFailed)
local BulkPurchaseStarted = require(BulkPurchaseApp.Store.Actions.BulkPurchaseStarted)
local BulkPurchaseRequested = require(BulkPurchaseApp.Store.Actions.BulkPurchaseRequested)

require(BulkPurchaseApp.Store.Types)

local function createInitialState() -- line: 21
	-- upvalues: BulkPurchasePromptStateEnum (copy)
	return {
		promptState = BulkPurchasePromptStateEnum.None
	}
end

return (Rodux.createReducer({
	promptState = BulkPurchasePromptStateEnum.None
}, {
	[BulkPurchaseEnded.name] = function(_, _) -- line: 28
		-- upvalues: BulkPurchasePromptStateEnum (copy)
		return {
			promptState = BulkPurchasePromptStateEnum.None
		}
	end,
	[BulkPurchaseSucceeded.name] = function(p3, p4) -- line: 31
		local v15 = table.clone(p3)

		v15.itemStatuses = p4.itemStatuses
		v15.promptState = p4.promptState

		return v15
	end,
	[BulkPurchaseFailed.name] = function(p5, p6) -- line: 37
		-- upvalues: BulkPurchasePromptStateEnum (copy)
		local v18 = table.clone(p5)

		v18.errorCode = p6.errorCode
		v18.promptState = BulkPurchasePromptStateEnum.Error
		v18.errorMetadata = p6.errorMetadata

		return v18
	end,
	[BulkPurchaseRequested.name] = function(p7, p8) -- line: 44
		local v21 = table.clone(p7)

		v21.itemData = p8.itemData
		v21.options = p8.options
		v21.orderRequest = p8.orderRequest
		v21.balance = p8.balance
		v21.totalCost = p8.totalCost
		v21.discountInformation = p8.discountInformation

		return v21
	end,
	[BulkPurchaseStarted.name] = function(p9, p10) -- line: 54
		-- upvalues: BulkPurchasePromptStateEnum (copy)
		local v24 = table.clone(p9)

		v24.promptState = BulkPurchasePromptStateEnum.Request
		v24.balance = p10.balance

		return v24
	end
}))
