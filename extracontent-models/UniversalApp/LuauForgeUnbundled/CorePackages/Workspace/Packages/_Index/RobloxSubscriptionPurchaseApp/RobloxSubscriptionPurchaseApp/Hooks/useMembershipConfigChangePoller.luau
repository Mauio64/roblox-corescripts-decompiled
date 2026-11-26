local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local RobloxSubscriptionSignals = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionSignals")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
local finalizeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/finalizeRobloxSubscriptionUpsellFlow")
local getRobloxSubscriptionMembershipConfig = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/getRobloxSubscriptionMembershipConfig")
local MembershipConfigChangeCheck = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/MembershipConfigChangeCheck")
local FIntPlusUpgradePollingIntervalMs = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FIntPlusUpgradePollingIntervalMs")

local function useMembershipConfigChangePoller()
	local v5 = RobloxSubscriptionStore.get()
	local ref = React.useRef(v5)

	local v6 = SignalsReact.useSignalState(v5.getPromptState)

	React.useEffect(function()
		if v6 ~= PromptState.SubscriptionStatusPolling then
			return nil
		end

		local current = ref.current
		local membershipConfigSnapshot = current.getMembershipConfigSnapshot()

		if membershipConfigSnapshot == nil then
			return nil
		end

		local v7 = false
		local function isStillPolling(): boolean
			return not v7 and current.getPromptState() == PromptState.SubscriptionStatusPolling
		end

		local function scheduleCheck()
			task.delay(FIntPlusUpgradePollingIntervalMs / 1000, function()
				if v7 or current.getPromptState() ~= PromptState.SubscriptionStatusPolling then
					return
				end

				getRobloxSubscriptionMembershipConfig():andThen(function(p2)
					if v7 or current.getPromptState() ~= PromptState.SubscriptionStatusPolling then
						return
					end

					if p2 == nil or not MembershipConfigChangeCheck.isChanged(membershipConfigSnapshot, p2) then
						scheduleCheck()
						return
					end

					local v8 = RobloxSubscriptionSignals.get()
					v8.setHasRobloxSubscriptionUpgradedThisSession(true)

					if next(membershipConfigSnapshot) ~= nil and v8.getHasRobloxSubscription() then
						v8.setExistingSubscriptionUpgradedThisSession(true)
					end

					finalizeRobloxSubscriptionUpsellFlow(true)
				end)
			end)
		end

		task.delay(FIntPlusUpgradePollingIntervalMs / 1000, function()
			if v7 or current.getPromptState() ~= PromptState.SubscriptionStatusPolling then
				return
			end

			getRobloxSubscriptionMembershipConfig():andThen(function(p2)
				if v7 or current.getPromptState() ~= PromptState.SubscriptionStatusPolling then
					return
				end

				if p2 == nil or not MembershipConfigChangeCheck.isChanged(membershipConfigSnapshot, p2) then
					scheduleCheck()
					return
				end

				local v8 = RobloxSubscriptionSignals.get()
				v8.setHasRobloxSubscriptionUpgradedThisSession(true)

				if next(membershipConfigSnapshot) ~= nil and v8.getHasRobloxSubscription() then
					v8.setExistingSubscriptionUpgradedThisSession(true)
				end

				finalizeRobloxSubscriptionUpsellFlow(true)
			end)
		end)

		return function()
			v7 = true
		end
	end, { v6 })
end

return useMembershipConfigChangePoller
