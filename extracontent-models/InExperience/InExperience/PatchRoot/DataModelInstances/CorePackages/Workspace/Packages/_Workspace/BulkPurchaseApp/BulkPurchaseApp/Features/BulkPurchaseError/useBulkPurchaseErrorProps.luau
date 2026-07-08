local MarketplaceService = game:GetService("MarketplaceService")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDispatch = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local BulkPurchaseEnded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseEnded)
local selectPurchaseResults = require(BulkPurchaseApp.Store.Selectors.selectPurchaseResults)
local selectErrorCode = require(BulkPurchaseApp.Store.Selectors.selectErrorCode)
local selectErrorMetadata = require(BulkPurchaseApp.Store.Selectors.selectErrorMetadata)

require(BulkPurchaseApp.Enums.ErrorCodeEnum)
require(script.Parent.BulkPurchaseError)

local function useBulkPurchaseErrorProps() -- line: 16
	-- upvalues: useSelector (copy), selectPurchaseResults (copy), selectErrorCode (copy), selectErrorMetadata (copy), useDispatch (copy), React (copy), MarketplaceService (copy), BulkPurchaseEnded (copy)
	local v12 = useSelector(selectPurchaseResults)
	local v13 = useSelector(selectErrorCode)
	local v14 = useSelector(selectErrorMetadata)
	local v15 = useDispatch()

	return {
		onDismiss = React.useCallback(function() -- line: 22
			-- upvalues: MarketplaceService (copy), v12 (copy), v15 (copy), BulkPurchaseEnded (copy)
			MarketplaceService:signalPromptBulkPurchaseFinished(3, v12)
			v15(BulkPurchaseEnded())
		end, {
			v12,
			v15
		}),
		errorCode = v13,
		errorMetadata = v14
	}
end

return useBulkPurchaseErrorProps
