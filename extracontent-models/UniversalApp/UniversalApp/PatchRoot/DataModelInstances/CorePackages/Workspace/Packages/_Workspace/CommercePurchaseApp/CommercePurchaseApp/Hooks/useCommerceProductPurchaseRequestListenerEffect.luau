local CommerceService = game:GetService("CommerceService")
local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local CommercePurchaseAppParent = CommercePurchaseApp.Parent
local React = require(CommercePurchaseAppParent.React)
local useDispatch = require(CommercePurchaseAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CommercePurchaseAppParent.Localization).Hooks.useLocalization
local useSelector = require(CommercePurchaseAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local CommercePurchasePromptStateEnum = require(CommercePurchaseApp.Enums.CommercePurchasePromptStateEnum)
local selectPromptState = require(CommercePurchaseApp.Store.Selectors.selectPromptState)
local InitiateCommercePurchaseFlow = require(CommercePurchaseApp.Store.Thunks.InitiateCommercePurchaseFlow)
local FFlagAddCommerceErrors = require(CommercePurchaseApp.Flags.FFlagAddCommerceErrors)

local function useCommercePurchaseRequestListenerEffect() -- line: 15
	-- upvalues: useDispatch (copy), useSelector (copy), selectPromptState (copy), useLocalization (copy), FFlagAddCommerceErrors (copy), React (copy), CommerceService (copy), CommercePurchasePromptStateEnum (copy), InitiateCommercePurchaseFlow (copy)
	local v13 = useDispatch()
	local v14 = useSelector(selectPromptState)
	local v15 = useLocalization({
		genericError = not FFlagAddCommerceErrors and "CoreScripts.CommercePurchasePrompt.ErrorPrompt.GenericError" or "CoreScripts.CommercePurchasePrompt.ErrorPrompt.Body.ErrorLoading"
	})

	React.useEffect(function() -- line: 24
		-- upvalues: v13 (copy), CommerceService (copy), v14 (copy), CommercePurchasePromptStateEnum (copy), InitiateCommercePurchaseFlow (copy), v15 (copy)
		local connection = nil

		if v13 then
			connection = CommerceService.PromptCommerceProductPurchaseRequested:Connect(function(s1: string) -- line: 28
				-- upvalues: v14 (copy), CommercePurchasePromptStateEnum (copy), v13 (copy), InitiateCommercePurchaseFlow (copy), v15 (copy)
				if v14 == CommercePurchasePromptStateEnum.None then
					v13(InitiateCommercePurchaseFlow(s1, v15.genericError))
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
		v15
	})
end

return useCommercePurchaseRequestListenerEffect
