local CommerceService = game:GetService("CommerceService")

local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local parent = CommercePurchaseApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local CommercePurchasePromptStateEnum = require(CommercePurchaseApp.Enums.CommercePurchasePromptStateEnum)
local selectPromptState = require(CommercePurchaseApp.Store.Selectors.selectPromptState)
local InitiateCommercePurchaseFlow = require(CommercePurchaseApp.Store.Thunks.InitiateCommercePurchaseFlow)
local FFlagAddCommerceErrors = require(CommercePurchaseApp.Flags.FFlagAddCommerceErrors)

local function useCommercePurchaseRequestListenerEffect()
	local v = useDispatch()
	local v2 = useSelector(selectPromptState)
	local v3 = useLocalization({
		genericError = FFlagAddCommerceErrors and "CoreScripts.CommercePurchasePrompt.ErrorPrompt.Body.ErrorLoading" or "CoreScripts.CommercePurchasePrompt.ErrorPrompt.GenericError"
	})

	React.useEffect(function()
		local promptCommerceProductPurchaseRequestedConnection

		if v then
			promptCommerceProductPurchaseRequestedConnection = CommerceService.PromptCommerceProductPurchaseRequested:Connect(function(p: string)
				if v2 == CommercePurchasePromptStateEnum.None then
					v(InitiateCommercePurchaseFlow(p, v3.genericError))
				end
			end)
		else
			promptCommerceProductPurchaseRequestedConnection = nil
		end

		return function()
			if promptCommerceProductPurchaseRequestedConnection then
				promptCommerceProductPurchaseRequestedConnection:Disconnect()
				promptCommerceProductPurchaseRequestedConnection = nil
			end
		end
	end, { v, v3 })
end
return useCommercePurchaseRequestListenerEffect
