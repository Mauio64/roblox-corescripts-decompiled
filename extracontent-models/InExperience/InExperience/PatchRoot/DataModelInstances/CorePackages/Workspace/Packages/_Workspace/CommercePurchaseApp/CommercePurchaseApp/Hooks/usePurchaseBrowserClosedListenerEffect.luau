local CommerceService = game:GetService("CommerceService")

local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local parent = CommercePurchaseApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local CommercePurchasePromptStateEnum = require(CommercePurchaseApp.Enums.CommercePurchasePromptStateEnum)
local selectPromptState = require(CommercePurchaseApp.Store.Selectors.selectPromptState)
local selectCommerceProductId = require(CommercePurchaseApp.Store.Selectors.selectCommerceProductId)
local selectCheckoutSessionId = require(CommercePurchaseApp.Store.Selectors.selectCheckoutSessionId)

local CommercePurchaseEnded = require(CommercePurchaseApp.Store.Actions.CommercePurchaseEnded)

local function usePurchaseBrowserClosedListenerEffect()
	local v = useDispatch()
	local v2 = useSelector(selectPromptState)
	local v3 = useSelector(selectCommerceProductId)
	local v4 = useSelector(selectCheckoutSessionId)
	React.useEffect(function()
		local purchaseBrowserClosedConnection

		if v then
			purchaseBrowserClosedConnection = CommerceService.PurchaseBrowserClosed:Connect(function()
				if v2 == CommercePurchasePromptStateEnum.Checkout then
					CommerceService:SignalPromptCommerceProductPurchaseFinished(v3, true, v4)

					v(CommercePurchaseEnded())
				end
			end)
		else
			purchaseBrowserClosedConnection = nil
		end

		return function()
			if purchaseBrowserClosedConnection then
				purchaseBrowserClosedConnection:Disconnect()
				purchaseBrowserClosedConnection = nil
			end
		end
	end, { v, v2, v3, v4 })
end
return usePurchaseBrowserClosedListenerEffect
