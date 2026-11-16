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
local selectErrorCode = require(BulkPurchaseApp.Store.Selectors.selectErrorCode)
local selectErrorMetadata = require(BulkPurchaseApp.Store.Selectors.selectErrorMetadata)
require(BulkPurchaseApp.Enums.ErrorCodeEnum)

require(script.Parent.BulkPurchaseError)

local function useBulkPurchaseErrorProps()
	local v = useSelector(selectPurchaseResults)
	local errorCode = useSelector(selectErrorCode)
	local errorMetadata = useSelector(selectErrorMetadata)
	local v2 = useDispatch()

	return {
		onDismiss = React.useCallback(function()
			MarketplaceService:signalPromptBulkPurchaseFinished(3, v)
			v2(BulkPurchaseEnded())
		end, { v, v2 }),
		errorCode = errorCode,
		errorMetadata = errorMetadata
	}
end

return useBulkPurchaseErrorProps
