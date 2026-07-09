local MarketplaceService = game:GetService("MarketplaceService")
local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local CancelSubscriptionAppParent = CancelSubscriptionApp.Parent
local React = require(CancelSubscriptionAppParent.React)
local useDispatch = require(CancelSubscriptionAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local InitiateCancelUserSubscriptionFlow = require(CancelSubscriptionApp.Store.Thunks.InitiateCancelUserSubscriptionFlow)
local useNetwork = require(CancelSubscriptionAppParent.EconomyCommonCoreScriptHooks).useNetwork
local CancelUserSubscriptionAsyncPromptStateEnum = require(CancelSubscriptionApp.Enums.CancelUserSubscriptionAsyncPromptStateEnum)

local function useCancelSubscriptionRequestedListenerEffect(p1) -- line: 11
	-- upvalues: useDispatch (copy), useNetwork (copy), React (copy), MarketplaceService (copy), CancelUserSubscriptionAsyncPromptStateEnum (copy), InitiateCancelUserSubscriptionFlow (copy)
	local v11 = useDispatch()
	local v12 = useNetwork()

	React.useEffect(function() -- line: 14
		-- upvalues: v11 (copy), v12 (copy), MarketplaceService (copy), p1 (copy), CancelUserSubscriptionAsyncPromptStateEnum (copy), InitiateCancelUserSubscriptionFlow (copy)
		local connection = nil

		if v11 and v12 then
			connection = MarketplaceService.PromptCancelSubscriptionRequested:Connect(function(s1: string) -- line: 18
				-- upvalues: p1 (copy), CancelUserSubscriptionAsyncPromptStateEnum (copy), v11 (copy), InitiateCancelUserSubscriptionFlow (copy), v12 (copy)
				if p1 == CancelUserSubscriptionAsyncPromptStateEnum.None then
					v11(InitiateCancelUserSubscriptionFlow(v12, s1))
				end
			end)
		end

		return function() -- line: 25
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v11,
		v12,
		p1
	})
end

return useCancelSubscriptionRequestedListenerEffect
