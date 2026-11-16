local MarketplaceService = game:GetService("MarketplaceService")
local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local parent = CancelSubscriptionApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local CancelSubscriptionEnded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionEnded)
local selectErrorState = require(CancelSubscriptionApp.Store.Selectors.selectErrorState)
local ErrorStateEnum = require(CancelSubscriptionApp.Enums.ErrorStateEnum)
local selectSubscriptionId = require(CancelSubscriptionApp.Store.Selectors.selectSubscriptionId)

require(script.Parent.CancelUserSubscriptionErrorPrompt)

local function useCancelUserSubscriptionErrorPromptProps()
	local errorState = useSelector(selectErrorState)
	local v = useDispatch()
	local v2 = useSelector(selectSubscriptionId) or ""

	return {
		onDismiss = React.useCallback(function()
			if errorState == ErrorStateEnum.Expiring then
				MarketplaceService:SignalUserSubscriptionStatusChanged(v2)
			end

			v(CancelSubscriptionEnded())
		end, { errorState, v }),
		errorState = errorState
	}
end

return useCancelUserSubscriptionErrorPromptProps
