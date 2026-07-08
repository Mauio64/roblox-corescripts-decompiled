local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local SignalsReact = require(RobloxSubscriptionPurchaseAppParent.SignalsReact)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local finalizeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.finalizeRobloxSubscriptionUpsellFlow)
local transitionToError = require(RobloxSubscriptionPurchaseApp.Actions.transitionToError)
local ErrorReason = require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local v10 = game:DefineFastInt("RobloxSubscriptionPurchasePollingTimeoutSeconds", 4)

local function useSubscriptionPollingTimeoutGuard() -- line: 20
	-- upvalues: RobloxSubscriptionStore (copy), React (copy), SignalsReact (copy), PromptState (copy), v10 (copy), transitionToError (copy), ErrorReason (copy), finalizeRobloxSubscriptionUpsellFlow (copy)
	local v12 = RobloxSubscriptionStore.get()
	local v13 = React.useRef(v12)
	local v14 = SignalsReact.useSignalState(v12.getPromptState)
	local v15 = SignalsReact.useSignalState(v12.getIsNativePurchase)

	React.useEffect(function() -- line: 28
		-- upvalues: v14 (copy), PromptState (copy), v10 (copy), v13 (copy), transitionToError (copy), ErrorReason (copy), finalizeRobloxSubscriptionUpsellFlow (copy)
		if v14 ~= PromptState.SubscriptionStatusPolling then
			return
		end

		local u16 = false

		task.delay(v10, function() -- line: 36
			-- upvalues: u16 (ref), v13 (copy), PromptState (copy), transitionToError (copy), ErrorReason (copy), finalizeRobloxSubscriptionUpsellFlow (copy)
			if u16 then
				return
			end

			local current = v13.current

			if current.getPromptState() == PromptState.SubscriptionStatusPolling then
				if current.getIsNativePurchase() then
					transitionToError(ErrorReason.GenericError, "useSubscriptionPollingTimeoutGuard")

					return
				end

				finalizeRobloxSubscriptionUpsellFlow(false)
			end
		end)

		return function() -- line: 55
			-- upvalues: u16 (ref)
			u16 = true
		end
	end, {
		v14,
		v15
	})
end

return useSubscriptionPollingTimeoutGuard
