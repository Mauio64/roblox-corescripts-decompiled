local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)

local SignalsReact = require(parent.SignalsReact)

local useNativePurchaseFinishedListener = require(RobloxSubscriptionPurchaseApp.Hooks.useNativePurchaseFinishedListener)
local useRobloxSubscriptionChangedListener = require(RobloxSubscriptionPurchaseApp.Hooks.useRobloxSubscriptionChangedListener)
local useSubscriptionPollingTimeoutGuard = require(RobloxSubscriptionPurchaseApp.Hooks.useSubscriptionPollingTimeoutGuard)
local useMembershipConfigChangePoller = require(RobloxSubscriptionPurchaseApp.Hooks.useMembershipConfigChangePoller)
local SharedFlags = require(parent.SharedFlags)
local FFlagPlusMembershipConfigChangeCheck = SharedFlags.FFlagPlusMembershipConfigChangeCheck

local Sheet = Foundation.Sheet
local DialogSize = Foundation.Enums.DialogSize

local BlackbirdSheetContent = require(script.Parent.BlackbirdSheetContent)
local ErrorSheetContent = require(script.Parent.ErrorSheetContent)

local errorSet = { [PromptState.Error] = true }

local set = {
	[PromptState.SubscriptionPurchaseUIReady] = true,
	[PromptState.SubscriptionPurchaseInProgress] = true,
	[PromptState.SubscriptionStatusPolling] = true,
	[PromptState.Error] = true
}

local function RobloxSubscriptionContainer()
	local v = RobloxSubscriptionStore.get()
	local v2 = SignalsReact.useSignalState(v.getPromptState)

	useNativePurchaseFinishedListener()
	useRobloxSubscriptionChangedListener()
	useSubscriptionPollingTimeoutGuard()

	if FFlagPlusMembershipConfigChangeCheck then
		useMembershipConfigChangePoller()
	end

	local blackbirdSheetContent = BlackbirdSheetContent()
	local errorSheetContent = ErrorSheetContent()

	if errorSet[v2] == true then
		blackbirdSheetContent = errorSheetContent
	end

	return set[v2] == true and React.createElement(Sheet.Root, {
		onClose = function()
			completeRobloxSubscriptionUpsellFlow()
		end,
		preferCenterSheet = true,
		size = DialogSize.Medium
	}, {
		Header = blackbirdSheetContent.Header,
		Content = blackbirdSheetContent.Content,
		Actions = blackbirdSheetContent.Actions
	}) or nil
end

return RobloxSubscriptionContainer
