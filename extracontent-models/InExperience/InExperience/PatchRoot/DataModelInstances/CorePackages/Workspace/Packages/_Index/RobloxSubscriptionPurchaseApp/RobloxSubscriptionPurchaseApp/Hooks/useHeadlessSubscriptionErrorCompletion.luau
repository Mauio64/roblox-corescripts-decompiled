local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local SignalsReact = require(RobloxSubscriptionPurchaseAppParent.SignalsReact)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)

local function useHeadlessSubscriptionErrorCompletion() -- line: 14
	-- upvalues: RobloxSubscriptionStore (copy), SignalsReact (copy), React (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
	local v9 = RobloxSubscriptionStore.get()
	local v10 = SignalsReact.useSignalState(v9.getPromptState)

	React.useEffect(function() -- line: 18
		-- upvalues: v10 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
		if v10 == PromptState.Error then
			completeRobloxSubscriptionUpsellFlow()
		end
	end, { v10 })
end

return useHeadlessSubscriptionErrorCompletion
