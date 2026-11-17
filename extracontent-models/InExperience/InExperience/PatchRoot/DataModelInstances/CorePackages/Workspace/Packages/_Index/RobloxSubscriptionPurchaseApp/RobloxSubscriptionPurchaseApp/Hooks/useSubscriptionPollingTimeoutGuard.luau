local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local finalizeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.finalizeRobloxSubscriptionUpsellFlow)
local transitionToError = require(RobloxSubscriptionPurchaseApp.Actions.transitionToError)
local ErrorReason = require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local SharedFlags = require(parent.SharedFlags)
local FFlagPlusMembershipConfigChangeCheck = SharedFlags.FFlagPlusMembershipConfigChangeCheck
local FIntPlusUpgradePollingTimeoutSeconds = require(RobloxSubscriptionPurchaseApp.Flags.FIntPlusUpgradePollingTimeoutSeconds)

local defineFastInt = game:DefineFastInt("RobloxSubscriptionPurchasePollingTimeoutSeconds", 4)

local function useSubscriptionPollingTimeoutGuard()
	local v = RobloxSubscriptionStore.get()
	local ref = React.useRef(v)

	local v2 = SignalsReact.useSignalState(v.getPromptState)
	local v3 = { v2, (SignalsReact.useSignalState(v.getIsNativePurchase)) }
	React.useEffect(function()
		if v2 ~= PromptState.SubscriptionStatusPolling then
			return
		end

		local flag = false
		local v4

		if FFlagPlusMembershipConfigChangeCheck and ref.current.getMembershipConfigSnapshot() ~= nil then
			v4 = FIntPlusUpgradePollingTimeoutSeconds
		else
			v4 = defineFastInt
		end

		task.delay(v4, function()
			if flag then
				return
			end

			local current = ref.current

			if current.getPromptState() == PromptState.SubscriptionStatusPolling then
				if current.getIsNativePurchase() then
					transitionToError(ErrorReason.GenericError, "useSubscriptionPollingTimeoutGuard")
				else
					finalizeRobloxSubscriptionUpsellFlow(false)
				end
			end
		end)

		return function()
			flag = true
		end
	end, v3)
end

return useSubscriptionPollingTimeoutGuard
