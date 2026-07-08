local MarketplaceService = game:GetService("MarketplaceService")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local useDispatch = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local BulkPurchaseEnded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseEnded)
local selectPurchaseResults = require(BulkPurchaseApp.Store.Selectors.selectPurchaseResults)

require(script.Parent.BulkPurchaseSuccess)

local function useBulkPurchaseSuccessProps() -- line: 12
	-- upvalues: useDispatch (copy), useSelector (copy), selectPurchaseResults (copy), MarketplaceService (copy), BulkPurchaseEnded (copy)
	local v9 = useDispatch()
	local v10 = useSelector(selectPurchaseResults)
	local n1 = 0

	for _, v13 in v10.Items do
		if v13.status == Enum.MarketplaceItemPurchaseStatus.Success then
			n1 += 1
		end
	end

	return {
		onDismiss = function() -- line: 23
			-- upvalues: MarketplaceService (copy), v10 (copy), v9 (copy), BulkPurchaseEnded (copy)
			MarketplaceService:signalPromptBulkPurchaseFinished(1, v10)
			v9(BulkPurchaseEnded())
		end,
		itemCount = n1
	}
end

return useBulkPurchaseSuccessProps
