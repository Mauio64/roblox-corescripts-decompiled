local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)
local useNativePurchaseFinishedListener = require(RobloxSubscriptionPurchaseApp.Hooks.useNativePurchaseFinishedListener)
local FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback)
local useRobloxSubscriptionChangedListener = require(RobloxSubscriptionPurchaseApp.Hooks.useRobloxSubscriptionChangedListener)
local useSubscriptionPollingTimeoutGuard = require(RobloxSubscriptionPurchaseApp.Hooks.useSubscriptionPollingTimeoutGuard)
local useHeadlessSubscriptionErrorCompletion = require(RobloxSubscriptionPurchaseApp.Hooks.useHeadlessSubscriptionErrorCompletion)

local function RobloxSubscriptionHeadlessListenerHost() -- line: 15
	-- upvalues: FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback (copy), useNativePurchaseFinishedListener (copy), completeRobloxSubscriptionUpsellFlow (copy), useRobloxSubscriptionChangedListener (copy), useSubscriptionPollingTimeoutGuard (copy), useHeadlessSubscriptionErrorCompletion (copy)
	if FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback then
		useNativePurchaseFinishedListener(nil, nil, function() -- line: 17
			-- upvalues: completeRobloxSubscriptionUpsellFlow (copy)
			completeRobloxSubscriptionUpsellFlow()
		end)
	else
		useNativePurchaseFinishedListener()
	end

	useRobloxSubscriptionChangedListener()
	useSubscriptionPollingTimeoutGuard()
	useHeadlessSubscriptionErrorCompletion()

	return nil
end

return RobloxSubscriptionHeadlessListenerHost
