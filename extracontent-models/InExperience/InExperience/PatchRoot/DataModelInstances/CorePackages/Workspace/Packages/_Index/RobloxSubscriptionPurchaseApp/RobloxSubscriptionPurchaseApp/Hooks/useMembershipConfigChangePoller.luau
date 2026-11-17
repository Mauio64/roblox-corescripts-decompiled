local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local RobloxSubscriptionSignals = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionSignals)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local finalizeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.finalizeRobloxSubscriptionUpsellFlow)
local getRobloxSubscriptionMembershipConfig = require(RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionMembershipConfig)
local MembershipConfigChangeCheck = require(RobloxSubscriptionPurchaseApp.Utils.MembershipConfigChangeCheck)
local FIntPlusUpgradePollingIntervalMs = require(RobloxSubscriptionPurchaseApp.Flags.FIntPlusUpgradePollingIntervalMs)

local function useMembershipConfigChangePoller()
	local v = RobloxSubscriptionStore.get()
	local ref = React.useRef(v)

	local v2 = SignalsReact.useSignalState(v.getPromptState)

	React.useEffect(function()
		if v2 ~= PromptState.SubscriptionStatusPolling then
			return nil
		end

		local current = ref.current
		local membershipConfigSnapshot = current.getMembershipConfigSnapshot()

		if membershipConfigSnapshot == nil then
			return nil
		end

		local v3 = false
		local function isStillPolling(): boolean -- 4 equivalent calls inferred from this helper
			return not v3 and current.getPromptState() == PromptState.SubscriptionStatusPolling
		end

		local function scheduleCheck()
			task.delay(FIntPlusUpgradePollingIntervalMs / 1000, function()
				if not isStillPolling() then -- inferred equivalent call
					return
				end

				getRobloxSubscriptionMembershipConfig():andThen(function(p)
					if not isStillPolling() then -- inferred equivalent call
						return
					end

					if p == nil or not MembershipConfigChangeCheck.isChanged(membershipConfigSnapshot, p) then
						scheduleCheck()
						return
					end

					local v4 = RobloxSubscriptionSignals.get()
					v4.setHasRobloxSubscriptionUpgradedThisSession(true)

					if next(membershipConfigSnapshot) ~= nil and v4.getHasRobloxSubscription() then
						v4.setExistingSubscriptionUpgradedThisSession(true)
					end

					finalizeRobloxSubscriptionUpsellFlow(true)
				end)
			end)
		end

		task.delay(FIntPlusUpgradePollingIntervalMs / 1000, function()
			if not isStillPolling() then -- inferred equivalent call
				return
			end

			getRobloxSubscriptionMembershipConfig():andThen(function(p)
				if not isStillPolling() then -- inferred equivalent call
					return
				end

				if p == nil or not MembershipConfigChangeCheck.isChanged(membershipConfigSnapshot, p) then
					scheduleCheck()
					return
				end

				local v4 = RobloxSubscriptionSignals.get()
				v4.setHasRobloxSubscriptionUpgradedThisSession(true)

				if next(membershipConfigSnapshot) ~= nil and v4.getHasRobloxSubscription() then
					v4.setExistingSubscriptionUpgradedThisSession(true)
				end

				finalizeRobloxSubscriptionUpsellFlow(true)
			end)
		end)

		return function()
			v3 = true
		end
	end, { v2 })
end

return useMembershipConfigChangePoller
