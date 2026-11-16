local CommerceService = game:GetService("CommerceService")
local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local parent = CommercePurchaseApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local CommercePurchaseEnded = require(CommercePurchaseApp.Store.Actions.CommercePurchaseEnded)
local selectErrorCode = require(CommercePurchaseApp.Store.Selectors.selectErrorCode)
local selectCommerceProductId = require(CommercePurchaseApp.Store.Selectors.selectCommerceProductId)
require(CommercePurchaseApp.Enums.ErrorCodeEnum)

require(script.Parent.CommercePurchaseError)

local function useCommercePurchaseErrorProps()
	local errorCode = useSelector(selectErrorCode)
	local v = useSelector(selectCommerceProductId)
	local v2 = useDispatch()

	return {
		onDismiss = React.useCallback(function()
			CommerceService:SignalPromptCommerceProductPurchaseFinished(v, false)
			v2(CommercePurchaseEnded())
		end, { v, v2 }),
		errorCode = errorCode
	}
end

return useCommercePurchaseErrorProps
