local CommerceService = game:GetService("CommerceService")
local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local CommercePurchaseAppParent = CommercePurchaseApp.Parent
local React = require(CommercePurchaseAppParent.React)
local useDispatch = require(CommercePurchaseAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CommercePurchaseAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local CommercePurchasePromptStateEnum = require(CommercePurchaseApp.Enums.CommercePurchasePromptStateEnum)
local selectPromptState = require(CommercePurchaseApp.Store.Selectors.selectPromptState)
local selectCommerceProductId = require(CommercePurchaseApp.Store.Selectors.selectCommerceProductId)
local selectCheckoutSessionId = require(CommercePurchaseApp.Store.Selectors.selectCheckoutSessionId)
local CommercePurchaseEnded = require(CommercePurchaseApp.Store.Actions.CommercePurchaseEnded)

local function usePurchaseBrowserClosedListenerEffect() -- line: 16
	-- upvalues: useDispatch (copy), useSelector (copy), selectPromptState (copy), selectCommerceProductId (copy), selectCheckoutSessionId (copy), React (copy), CommerceService (copy), CommercePurchasePromptStateEnum (copy), CommercePurchaseEnded (copy)
	local v13 = useDispatch()
	local v14 = useSelector(selectPromptState)
	local v15 = useSelector(selectCommerceProductId)
	local v16 = useSelector(selectCheckoutSessionId)

	React.useEffect(function() -- line: 21
		-- upvalues: v13 (copy), CommerceService (copy), v14 (copy), CommercePurchasePromptStateEnum (copy), v15 (copy), v16 (copy), CommercePurchaseEnded (copy)
		local connection = nil

		if v13 then
			connection = CommerceService.PurchaseBrowserClosed:Connect(function() -- line: 24
				-- upvalues: v14 (copy), CommercePurchasePromptStateEnum (copy), CommerceService (copy), v15 (copy), v16 (copy), v13 (copy), CommercePurchaseEnded (copy)
				if v14 == CommercePurchasePromptStateEnum.Checkout then
					CommerceService:SignalPromptCommerceProductPurchaseFinished(v15, true, v16)
					v13(CommercePurchaseEnded())
				end
			end)
		end

		return function() -- line: 35
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v13,
		v14,
		v15,
		v16
	})
end

return usePurchaseBrowserClosedListenerEffect
