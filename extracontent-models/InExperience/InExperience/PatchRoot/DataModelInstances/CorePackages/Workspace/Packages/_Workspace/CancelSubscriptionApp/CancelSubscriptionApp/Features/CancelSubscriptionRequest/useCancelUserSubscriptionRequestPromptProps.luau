local MarketplaceService = game:GetService("MarketplaceService")
local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local parent = CancelSubscriptionApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local CancelSubscriptionEnded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionEnded)
local CancelSubscriptionSucceeded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionSucceeded)
local CancelSubscriptionFailed = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionFailed)
local CancelSubscriptionRequested = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionRequested)
local ErrorStateEnum = require(CancelSubscriptionApp.Enums.ErrorStateEnum)
require(CancelSubscriptionApp.Store.Types)
local selectExpirationDate = require(CancelSubscriptionApp.Store.Selectors.selectExpirationDate)
local selectSubscriptionId = require(CancelSubscriptionApp.Store.Selectors.selectSubscriptionId)

require(script.Parent.CancelUserSubscriptionRequestPrompt)

local function useCancelUserSubscriptionRequestPromptProps()
	local expirationDate = useSelector(selectExpirationDate) or ""
	local subscriptionId = useSelector(selectSubscriptionId) or ""
	local v = useDispatch()

	return {
		onCancel = React.useCallback(function()
			v(CancelSubscriptionEnded())
		end, { v }),
		onConfirm = React.useCallback(function()
			v(CancelSubscriptionRequested())
			local success, _ = pcall(function()
				return MarketplaceService:PerformCancelSubscription(subscriptionId)
			end)

			if success then
				v(CancelSubscriptionSucceeded(subscriptionId))
			else
				v(CancelSubscriptionFailed(ErrorStateEnum.ErrorCancelling, subscriptionId))
			end
		end, { v }),
		expirationDate = expirationDate,
		subscriptionId = subscriptionId
	}
end

return useCancelUserSubscriptionRequestPromptProps
