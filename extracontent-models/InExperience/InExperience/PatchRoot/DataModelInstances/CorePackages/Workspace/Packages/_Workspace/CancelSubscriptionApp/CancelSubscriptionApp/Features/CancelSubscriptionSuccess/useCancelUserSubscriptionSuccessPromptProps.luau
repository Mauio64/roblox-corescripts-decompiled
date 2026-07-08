local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local CancelSubscriptionAppParent = CancelSubscriptionApp.Parent
local React = require(CancelSubscriptionAppParent.React)
local useDispatch = require(CancelSubscriptionAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local MarketplaceService = game:GetService("MarketplaceService")
local useSelector = require(CancelSubscriptionAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local selectSubscriptionId = require(CancelSubscriptionApp.Store.Selectors.selectSubscriptionId)
local CancelSubscriptionEnded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionEnded)

require(CancelSubscriptionApp.Store.Types)
require(script.Parent.CancelUserSubscriptionSuccessPrompt)

local function useCancelUserSubscriptionSuccessPromptProps() -- line: 19
	-- upvalues: useDispatch (copy), useSelector (copy), selectSubscriptionId (copy), React (copy), MarketplaceService (copy), CancelSubscriptionEnded (copy)
	local v10 = useDispatch()
	local v11 = useSelector(selectSubscriptionId) or ""

	return {
		onDismissed = React.useCallback(function() -- line: 23
			-- upvalues: MarketplaceService (copy), v11 (copy), v10 (copy), CancelSubscriptionEnded (copy)
			MarketplaceService:SignalUserSubscriptionStatusChanged(v11)
			v10(CancelSubscriptionEnded())
		end, { v10 })
	}
end

return useCancelUserSubscriptionSuccessPromptProps
