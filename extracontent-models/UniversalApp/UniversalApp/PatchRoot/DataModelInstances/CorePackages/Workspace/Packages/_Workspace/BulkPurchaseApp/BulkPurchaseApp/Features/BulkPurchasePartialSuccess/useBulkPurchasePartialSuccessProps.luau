local MarketplaceService = game:GetService("MarketplaceService")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDispatch = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local BulkPurchaseEnded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseEnded)
local selectPurchaseResults = require(BulkPurchaseApp.Store.Selectors.selectPurchaseResults)
local getThumbnailUrl = require(BulkPurchaseApp.Utils.getThumbnailUrl)

require(BulkPurchaseApp.Store.Types)
require(script.Parent.BulkPurchasePartialSuccess)

local function createBulkPurchasePartialSuccessItem(p1, p2) -- line: 18
	-- upvalues: getThumbnailUrl (copy)
	return {
		id = p1.id,
		image = getThumbnailUrl(p1.id, p1.type),
		name = p1.name,
		status = p2
	}
end
local function selectBulkPurchasePartialSuccessState(p3) -- line: 30
	-- upvalues: getThumbnailUrl (copy)
	local t1 = {}
	local t2 = {}
	local n1 = 0

	if p3.itemData and p3.itemStatuses then
		for _, v20 in p3.itemData do
			local v21 = p3.itemStatuses[v20.id]
			local t3 = {
				id = v20.id,
				image = getThumbnailUrl(v20.id, v20.type),
				name = v20.name,
				status = v21
			}

			if v21 == Enum.MarketplaceItemPurchaseStatus.Success then
				n1 += v20.priceRobux
				table.insert(t1, t3)
			elseif v21 then
				table.insert(t2, t3)
			end
		end
	end

	return {
		robuxSpent = n1,
		currentBalance = p3.balance or 0,
		unsuccessfulItems = t2,
		successfulItems = t1
	}
end
local function useBulkPurchasePartialSuccessProps() -- line: 54
	-- upvalues: useSelector (copy), selectPurchaseResults (copy), selectBulkPurchasePartialSuccessState (copy), useDispatch (copy), React (copy), MarketplaceService (copy), BulkPurchaseEnded (copy)
	local v23 = useSelector(selectPurchaseResults)
	local v24 = useSelector(selectBulkPurchasePartialSuccessState)
	local v25 = useDispatch()

	return {
		onDismiss = React.useCallback(function() -- line: 59
			-- upvalues: MarketplaceService (copy), v23 (copy), v25 (copy), BulkPurchaseEnded (copy)
			MarketplaceService:signalPromptBulkPurchaseFinished(1, v23)
			v25(BulkPurchaseEnded())
		end, {
			v23,
			v25
		}),
		successfulItems = v24.successfulItems,
		unsuccessfulItems = v24.unsuccessfulItems,
		robuxSpent = v24.robuxSpent,
		currentBalance = v24.currentBalance
	}
end

return useBulkPurchasePartialSuccessProps
