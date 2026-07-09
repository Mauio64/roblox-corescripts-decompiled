local MarketplaceService = game:GetService("MarketplaceService")
local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local CancelSubscriptionAppParent = CancelSubscriptionApp.Parent
local React = require(CancelSubscriptionAppParent.React)
local useDispatch = require(CancelSubscriptionAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CancelSubscriptionAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local CancelSubscriptionEnded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionEnded)
local selectErrorState = require(CancelSubscriptionApp.Store.Selectors.selectErrorState)
local ErrorStateEnum = require(CancelSubscriptionApp.Enums.ErrorStateEnum)
local selectSubscriptionId = require(CancelSubscriptionApp.Store.Selectors.selectSubscriptionId)

require(script.Parent.CancelUserSubscriptionErrorPrompt)

local function useCancelUserSubscriptionErrorPromptProps() -- line: 15
	-- upvalues: useSelector (copy), selectErrorState (copy), useDispatch (copy), selectSubscriptionId (copy), React (copy), ErrorStateEnum (copy), MarketplaceService (copy), CancelSubscriptionEnded (copy)
	local v12 = useSelector(selectErrorState)
	local v13 = useDispatch()
	local v14 = useSelector(selectSubscriptionId) or ""

	return {
		onDismiss = React.useCallback(function() -- line: 20
			-- upvalues: v12 (copy), ErrorStateEnum (copy), MarketplaceService (copy), v14 (copy), v13 (copy), CancelSubscriptionEnded (copy)
			if v12 == ErrorStateEnum.Expiring then
				MarketplaceService:SignalUserSubscriptionStatusChanged(v14)
			end

			v13(CancelSubscriptionEnded())
		end, {
			v12,
			v13
		}),
		errorState = v12
	}
end

return useCancelUserSubscriptionErrorPromptProps
