local MarketplaceService = game:GetService("MarketplaceService")
local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local parent = CancelSubscriptionApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local InitiateCancelUserSubscriptionFlow = require(CancelSubscriptionApp.Store.Thunks.InitiateCancelUserSubscriptionFlow)
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local useNetwork = EconomyCommonCoreScriptHooks.useNetwork
local CancelUserSubscriptionAsyncPromptStateEnum = require(CancelSubscriptionApp.Enums.CancelUserSubscriptionAsyncPromptStateEnum)

local function useCancelSubscriptionRequestedListenerEffect(p)
	local v = useDispatch()
	local v2 = useNetwork()
	React.useEffect(function()
		local promptCancelSubscriptionRequestedConnection

		if v and v2 then
			promptCancelSubscriptionRequestedConnection = MarketplaceService.PromptCancelSubscriptionRequested:Connect(function(p2: string)
				if p == CancelUserSubscriptionAsyncPromptStateEnum.None then
					v(InitiateCancelUserSubscriptionFlow(v2, p2))
				end
			end)
		else
			promptCancelSubscriptionRequestedConnection = nil
		end

		return function()
			if promptCancelSubscriptionRequestedConnection then
				promptCancelSubscriptionRequestedConnection:Disconnect()
				promptCancelSubscriptionRequestedConnection = nil
			end
		end
	end, { v, v2, p })
end
return useCancelSubscriptionRequestedListenerEffect
