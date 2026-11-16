local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local parent = CancelSubscriptionApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local MarketplaceService = game:GetService("MarketplaceService")
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local selectSubscriptionId = require(CancelSubscriptionApp.Store.Selectors.selectSubscriptionId)

local CancelSubscriptionEnded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionEnded)
require(CancelSubscriptionApp.Store.Types)

require(script.Parent.CancelUserSubscriptionSuccessPrompt)

local function useCancelUserSubscriptionSuccessPromptProps()
	local v = useDispatch()
	local v2 = useSelector(selectSubscriptionId) or ""

	return {
		onDismissed = React.useCallback(function()
			MarketplaceService:SignalUserSubscriptionStatusChanged(v2)
			v(CancelSubscriptionEnded())
		end, { v })
	}
end

return useCancelUserSubscriptionSuccessPromptProps
