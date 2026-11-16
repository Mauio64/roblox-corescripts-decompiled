local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local Rodux = require(parent.Rodux)

local BulkPurchasePromptStateEnum = require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)
local BulkPurchaseEnded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseEnded)
local BulkPurchaseSucceeded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseSucceeded)
local BulkPurchaseFailed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseFailed)
local BulkPurchaseStarted = require(BulkPurchaseApp.Store.Actions.BulkPurchaseStarted)
local BulkPurchaseRequested = require(BulkPurchaseApp.Store.Actions.BulkPurchaseRequested)
local BulkPurchaseRefreshed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseRefreshed)
local BulkPurchaseDisablePurchase = require(BulkPurchaseApp.Store.Actions.BulkPurchaseDisablePurchase)

require(BulkPurchaseApp.Store.Types)

local FFlagBulkPurchaseRemoveStartedAction = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseRemoveStartedAction)
local FFlagAXAddPlusUpsellToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddPlusUpsellToBulkPurchase)
local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)

local function createInitialState() -- 2 equivalent calls inferred from this helper
	return { promptState = BulkPurchasePromptStateEnum.None }
end

local createReducer = Rodux.createReducer
local initialState = createInitialState() -- inferred equivalent call
return (createReducer(initialState, {
	[BulkPurchaseEnded.name] = function(_, _)
		return createInitialState() -- inferred equivalent call
	end,
	[BulkPurchaseSucceeded.name] = function(p, p2)
		local clone = table.clone(p)
		clone.itemStatuses = p2.itemStatuses
		clone.promptState = p2.promptState

		if FFlagAXAddPlusUpsellToBulkPurchase then
			clone.disablePurchase = false
		end

		return clone
	end,
	[BulkPurchaseFailed.name] = function(p, p2)
		local clone = table.clone(p)
		clone.errorCode = p2.errorCode
		clone.promptState = BulkPurchasePromptStateEnum.Error
		clone.errorMetadata = p2.errorMetadata

		if FFlagAXAddPlusUpsellToBulkPurchase then
			clone.disablePurchase = false
		end

		return clone
	end,
	[BulkPurchaseRequested.name] = function(p, data)
		local clone = table.clone(p)
		clone.itemData = data.itemData
		clone.options = data.options
		clone.orderRequest = data.orderRequest
		clone.balance = data.balance
		clone.totalCost = data.totalCost
		clone.discountInformation = data.discountInformation

		if FFlagBulkPurchaseRemoveStartedAction then
			clone.promptState = BulkPurchasePromptStateEnum.Request
		end

		if FFlagAXAddOffersToBulkPurchase then
			clone.offerData = data.offerData
		end

		return clone
	end,
	[BulkPurchaseRefreshed.name] = function(p, data)
		local clone = table.clone(p)
		clone.itemData = data.itemData
		clone.options = data.options
		clone.orderRequest = data.orderRequest
		clone.balance = data.balance
		clone.totalCost = data.totalCost
		clone.discountInformation = data.discountInformation
		clone.disablePurchase = false

		if FFlagAXAddOffersToBulkPurchase then
			clone.offerData = data.offerData
		end

		return clone
	end,
	[BulkPurchaseDisablePurchase.name] = function(p, _)
		local clone = table.clone(p)
		clone.disablePurchase = true
		return clone
	end,
	[BulkPurchaseStarted.name] = function(p, p2)
		local clone = table.clone(p)
		clone.promptState = BulkPurchasePromptStateEnum.Request
		clone.balance = p2.balance
		return clone
	end
}))
