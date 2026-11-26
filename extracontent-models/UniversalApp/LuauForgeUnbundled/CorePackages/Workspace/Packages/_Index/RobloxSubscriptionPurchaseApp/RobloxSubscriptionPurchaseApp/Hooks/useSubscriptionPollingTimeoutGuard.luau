local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
local finalizeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/finalizeRobloxSubscriptionUpsellFlow")
local transitionToError = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/transitionToError")
local ErrorReason = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ErrorReason")
local fFlagPlusMembershipConfigChangeCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagPlusMembershipConfigChangeCheck
local FIntPlusUpgradePollingTimeoutSeconds = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FIntPlusUpgradePollingTimeoutSeconds")

local defineFastInt = game:DefineFastInt("RobloxSubscriptionPurchasePollingTimeoutSeconds", 4)

local function useSubscriptionPollingTimeoutGuard()
	local v5 = RobloxSubscriptionStore.get()
	local ref = React.useRef(v5)

	local v6 = SignalsReact.useSignalState(v5.getPromptState)
	local v7 = { v6, (SignalsReact.useSignalState(v5.getIsNativePurchase)) }
	React.useEffect(function()
		if v6 ~= PromptState.SubscriptionStatusPolling then
			return
		end

		local flag = false

		local v8 = if fFlagPlusMembershipConfigChangeCheck and ref.current.getMembershipConfigSnapshot() ~= nil then FIntPlusUpgradePollingTimeoutSeconds else defineFastInt

		task.delay(v8, function()
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
	end, v7)
end

return useSubscriptionPollingTimeoutGuard
