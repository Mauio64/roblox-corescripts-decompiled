local CommerceService = game:GetService("CommerceService")
local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local CommercePurchaseAppParent = CommercePurchaseApp.Parent
local React = require(CommercePurchaseAppParent.React)
local useDispatch = require(CommercePurchaseAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CommercePurchaseAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local CommercePurchaseEnded = require(CommercePurchaseApp.Store.Actions.CommercePurchaseEnded)
local selectErrorCode = require(CommercePurchaseApp.Store.Selectors.selectErrorCode)
local selectCommerceProductId = require(CommercePurchaseApp.Store.Selectors.selectCommerceProductId)

require(CommercePurchaseApp.Enums.ErrorCodeEnum)
require(script.Parent.CommercePurchaseError)

local function useCommercePurchaseErrorProps() -- line: 15
	-- upvalues: useSelector (copy), selectErrorCode (copy), selectCommerceProductId (copy), useDispatch (copy), React (copy), CommerceService (copy), CommercePurchaseEnded (copy)
	local v11 = useSelector(selectErrorCode)
	local v12 = useSelector(selectCommerceProductId)
	local v13 = useDispatch()

	return {
		onDismiss = React.useCallback(function() -- line: 20
			-- upvalues: CommerceService (copy), v12 (copy), v13 (copy), CommercePurchaseEnded (copy)
			CommerceService:SignalPromptCommerceProductPurchaseFinished(v12, false)
			v13(CommercePurchaseEnded())
		end, {
			v12,
			v13
		}),
		errorCode = v11
	}
end

return useCommercePurchaseErrorProps
