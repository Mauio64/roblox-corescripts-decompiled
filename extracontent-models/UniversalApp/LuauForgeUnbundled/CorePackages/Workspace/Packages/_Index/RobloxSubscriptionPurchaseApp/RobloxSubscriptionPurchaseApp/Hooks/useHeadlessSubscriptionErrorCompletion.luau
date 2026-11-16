local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")

local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
local completeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/completeRobloxSubscriptionUpsellFlow")

local function useHeadlessSubscriptionErrorCompletion()
	local v5 = RobloxSubscriptionStore.get()
	local v6 = SignalsReact.useSignalState(v5.getPromptState)

	React.useEffect(function()
		if v6 == PromptState.Error then
			completeRobloxSubscriptionUpsellFlow()
		end
	end, { v6 })
end

return useHeadlessSubscriptionErrorCompletion
