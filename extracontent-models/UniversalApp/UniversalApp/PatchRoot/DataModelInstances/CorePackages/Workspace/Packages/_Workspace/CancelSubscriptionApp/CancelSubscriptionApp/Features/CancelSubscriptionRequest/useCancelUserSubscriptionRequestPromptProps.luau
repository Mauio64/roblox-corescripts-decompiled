local MarketplaceService = game:GetService("MarketplaceService")
local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local CancelSubscriptionAppParent = CancelSubscriptionApp.Parent
local React = require(CancelSubscriptionAppParent.React)
local useDispatch = require(CancelSubscriptionAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CancelSubscriptionAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local CancelSubscriptionEnded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionEnded)
local CancelSubscriptionSucceeded = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionSucceeded)
local CancelSubscriptionFailed = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionFailed)
local CancelSubscriptionRequested = require(CancelSubscriptionApp.Store.Actions.CancelSubscriptionRequested)
local ErrorStateEnum = require(CancelSubscriptionApp.Enums.ErrorStateEnum)

require(CancelSubscriptionApp.Store.Types)

local selectExpirationDate = require(CancelSubscriptionApp.Store.Selectors.selectExpirationDate)
local selectSubscriptionId = require(CancelSubscriptionApp.Store.Selectors.selectSubscriptionId)

require(script.Parent.CancelUserSubscriptionRequestPrompt)

local function useCancelUserSubscriptionRequestPromptProps() -- line: 23
	-- upvalues: useSelector (copy), selectExpirationDate (copy), selectSubscriptionId (copy), useDispatch (copy), React (copy), CancelSubscriptionEnded (copy), CancelSubscriptionRequested (copy), MarketplaceService (copy), CancelSubscriptionSucceeded (copy), CancelSubscriptionFailed (copy), ErrorStateEnum (copy)
	local v15 = useSelector(selectExpirationDate) or ""
	local v16 = useSelector(selectSubscriptionId) or ""
	local v17 = useDispatch()
	local v18 = React.useCallback(function() -- line: 28
		-- upvalues: v17 (copy), CancelSubscriptionEnded (copy)
		v17(CancelSubscriptionEnded())
	end, { v17 })
	local v19 = React.useCallback(function() -- line: 32
		-- upvalues: v17 (copy), CancelSubscriptionRequested (copy), MarketplaceService (copy), v16 (copy), CancelSubscriptionSucceeded (copy), CancelSubscriptionFailed (copy), ErrorStateEnum (copy)
		v17(CancelSubscriptionRequested())

		local ok, _ = pcall(function() -- line: 34
			-- upvalues: MarketplaceService (copy), v16 (copy)
			return MarketplaceService:PerformCancelSubscription(v16)
		end)

		if ok then
			v17(CancelSubscriptionSucceeded(v16))

			return
		end

		v17(CancelSubscriptionFailed(ErrorStateEnum.ErrorCancelling, v16))
	end, { v17 })

	return {
		onCancel = v18,
		onConfirm = v19,
		expirationDate = v15,
		subscriptionId = v16
	}
end

return useCancelUserSubscriptionRequestPromptProps
