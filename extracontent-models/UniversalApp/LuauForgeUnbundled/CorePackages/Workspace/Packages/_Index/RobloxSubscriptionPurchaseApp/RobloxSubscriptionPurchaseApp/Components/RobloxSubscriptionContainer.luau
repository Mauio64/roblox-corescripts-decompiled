local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")

local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")

local completeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/completeRobloxSubscriptionUpsellFlow")

local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")

local useNativePurchaseFinishedListener = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Hooks/useNativePurchaseFinishedListener")
local useRobloxSubscriptionChangedListener = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Hooks/useRobloxSubscriptionChangedListener")
local useSubscriptionPollingTimeoutGuard = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Hooks/useSubscriptionPollingTimeoutGuard")
local useMembershipConfigChangePoller = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Hooks/useMembershipConfigChangePoller")
local fFlagPlusMembershipConfigChangeCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagPlusMembershipConfigChangeCheck

local sheet = Foundation.Sheet
local dialogSize = Foundation.Enums.DialogSize

local BlackbirdSheetContent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/BlackbirdSheetContent")
local ErrorSheetContent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/ErrorSheetContent")

local errorSet = { [PromptState.Error] = true }

local set = {
	[PromptState.SubscriptionPurchaseUIReady] = true,
	[PromptState.SubscriptionPurchaseInProgress] = true,
	[PromptState.SubscriptionStatusPolling] = true,
	[PromptState.Error] = true
}

local function RobloxSubscriptionContainer()
	local v5 = RobloxSubscriptionStore.get()
	local v6 = SignalsReact.useSignalState(v5.getPromptState)

	useNativePurchaseFinishedListener()
	useRobloxSubscriptionChangedListener()
	useSubscriptionPollingTimeoutGuard()

	if fFlagPlusMembershipConfigChangeCheck then
		useMembershipConfigChangePoller()
	end

	local v7 = BlackbirdSheetContent()
	local v8 = ErrorSheetContent()

	if errorSet[v6] == true then
		v7 = v8
	end

	return set[v6] == true and React.createElement(sheet.Root, {
		onClose = function()
			completeRobloxSubscriptionUpsellFlow()
		end,
		preferCenterSheet = true,
		size = dialogSize.Medium
	}, { Header = v7.Header, Content = v7.Content, Actions = v7.Actions }) or nil
end

return RobloxSubscriptionContainer
