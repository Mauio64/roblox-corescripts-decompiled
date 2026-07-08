local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local Foundation = require(RobloxSubscriptionPurchaseAppParent.Foundation)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)
local SignalsReact = require(RobloxSubscriptionPurchaseAppParent.SignalsReact)
local useNativePurchaseFinishedListener = require(RobloxSubscriptionPurchaseApp.Hooks.useNativePurchaseFinishedListener)
local useRobloxSubscriptionChangedListener = require(RobloxSubscriptionPurchaseApp.Hooks.useRobloxSubscriptionChangedListener)
local useSubscriptionPollingTimeoutGuard = require(RobloxSubscriptionPurchaseApp.Hooks.useSubscriptionPollingTimeoutGuard)
local Sheet = Foundation.Sheet
local DialogSize = Foundation.Enums.DialogSize
local BlackbirdSheetContent = require(script.Parent.BlackbirdSheetContent)
local ErrorSheetContent = require(script.Parent.ErrorSheetContent)
local t1 = {
	[PromptState.Error] = true
}
local t2 = {
	[PromptState.SubscriptionPurchaseUIReady] = true,
	[PromptState.SubscriptionPurchaseInProgress] = true,
	[PromptState.SubscriptionStatusPolling] = true,
	[PromptState.Error] = true
}

local function RobloxSubscriptionContainer() -- line: 46
	-- upvalues: RobloxSubscriptionStore (copy), SignalsReact (copy), useNativePurchaseFinishedListener (copy), useRobloxSubscriptionChangedListener (copy), useSubscriptionPollingTimeoutGuard (copy), BlackbirdSheetContent (copy), ErrorSheetContent (copy), t1 (copy), t2 (copy), React (copy), Sheet (copy), completeRobloxSubscriptionUpsellFlow (copy), DialogSize (copy)
	local v19 = RobloxSubscriptionStore.get()
	local v20 = SignalsReact.useSignalState(v19.getPromptState)

	useNativePurchaseFinishedListener()
	useRobloxSubscriptionChangedListener()
	useSubscriptionPollingTimeoutGuard()

	local v21 = BlackbirdSheetContent()
	local v22 = ErrorSheetContent()
	local v23 = if t1[v20] ~= true then v21 else v22

	return t2[v20] == true and React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = function() -- line: 66
			-- upvalues: completeRobloxSubscriptionUpsellFlow (copy)
			completeRobloxSubscriptionUpsellFlow()
		end,
		size = DialogSize.Medium
	}, {
		Header = v23.Header,
		Content = v23.Content,
		Actions = v23.Actions
	}) or nil
end

return RobloxSubscriptionContainer
