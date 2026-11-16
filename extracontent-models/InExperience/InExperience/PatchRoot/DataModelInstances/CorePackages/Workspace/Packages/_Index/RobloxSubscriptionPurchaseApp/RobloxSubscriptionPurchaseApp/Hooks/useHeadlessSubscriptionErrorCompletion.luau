local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)

local function useHeadlessSubscriptionErrorCompletion()
	local v = RobloxSubscriptionStore.get()
	local v2 = SignalsReact.useSignalState(v.getPromptState)

	React.useEffect(function()
		if v2 == PromptState.Error then
			completeRobloxSubscriptionUpsellFlow()
		end
	end, { v2 })
end

return useHeadlessSubscriptionErrorCompletion
