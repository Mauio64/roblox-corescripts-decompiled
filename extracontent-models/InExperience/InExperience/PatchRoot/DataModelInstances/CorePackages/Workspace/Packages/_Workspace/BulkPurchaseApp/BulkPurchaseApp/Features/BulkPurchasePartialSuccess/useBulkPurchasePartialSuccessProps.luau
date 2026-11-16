local MarketplaceService = game:GetService("MarketplaceService")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local BulkPurchaseEnded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseEnded)
local selectPurchaseResults = require(BulkPurchaseApp.Store.Selectors.selectPurchaseResults)
local getThumbnailUrl = require(BulkPurchaseApp.Utils.getThumbnailUrl)
require(BulkPurchaseApp.Store.Types)

require(script.Parent.BulkPurchasePartialSuccess)

local function createBulkPurchasePartialSuccessItem(data, itemStatus) -- 1 equivalent call inferred from this helper
	return {
		id = data.id,
		image = getThumbnailUrl(data.id, data.type),
		name = data.name,
		status = itemStatus
	}
end

local function selectBulkPurchasePartialSuccessState(data)
	local bulkPurchasePartialSuccessItems = {}
	local bulkPurchasePartialSuccessItems2 = {}
	local total = 0

	if data.itemData and data.itemStatuses then
		for _, v in data.itemData do
			local itemStatus = data.itemStatuses[v.id]
			local bulkPurchasePartialSuccessItem = createBulkPurchasePartialSuccessItem(v, itemStatus) -- inferred equivalent call

			if itemStatus == Enum.MarketplaceItemPurchaseStatus.Success then
				total += v.priceRobux
				table.insert(bulkPurchasePartialSuccessItems, bulkPurchasePartialSuccessItem)
			elseif itemStatus then
				table.insert(bulkPurchasePartialSuccessItems2, bulkPurchasePartialSuccessItem)
			end
		end
	end

	return {
		robuxSpent = total,
		currentBalance = data.balance or 0,
		unsuccessfulItems = bulkPurchasePartialSuccessItems2,
		successfulItems = bulkPurchasePartialSuccessItems
	}
end

local function useBulkPurchasePartialSuccessProps()
	local v = useSelector(selectPurchaseResults)
	local v2 = useSelector(selectBulkPurchasePartialSuccessState)
	local v3 = useDispatch()

	return {
		onDismiss = React.useCallback(function()
			MarketplaceService:signalPromptBulkPurchaseFinished(1, v)
			v3(BulkPurchaseEnded())
		end, { v, v3 }),
		successfulItems = v2.successfulItems,
		unsuccessfulItems = v2.unsuccessfulItems,
		robuxSpent = v2.robuxSpent,
		currentBalance = v2.currentBalance
	}
end

return useBulkPurchasePartialSuccessProps
