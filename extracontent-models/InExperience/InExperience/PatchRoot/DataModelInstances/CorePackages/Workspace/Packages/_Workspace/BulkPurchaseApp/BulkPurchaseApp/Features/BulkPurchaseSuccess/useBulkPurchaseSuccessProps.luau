local MarketplaceService = game:GetService("MarketplaceService")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local BulkPurchaseEnded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseEnded)
local selectPurchaseResults = require(BulkPurchaseApp.Store.Selectors.selectPurchaseResults)

require(script.Parent.BulkPurchaseSuccess)

local function useBulkPurchaseSuccessProps()
	local v = useDispatch()
	local v2 = useSelector(selectPurchaseResults)
	local count = 0

	for _, item in v2.Items do
		if item.status == Enum.MarketplaceItemPurchaseStatus.Success then
			count += 1
		end
	end

	return {
		onDismiss = function()
			MarketplaceService:signalPromptBulkPurchaseFinished(1, v2)
			v(BulkPurchaseEnded())
		end,
		itemCount = count
	}
end

return useBulkPurchaseSuccessProps
