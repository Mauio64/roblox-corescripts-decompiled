local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")

local getRobloxSubscriptionProducts = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/getRobloxSubscriptionProducts")
local isRobloxPlusFreeTrialEligible = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/isRobloxPlusFreeTrialEligible")

local function useRobloxPlusUpsellBannerViewModel(p2)
	local state, setState = React.useState(false)

	React.useEffect(function()
		local v5 = false
		getRobloxSubscriptionProducts():andThen(function(p3)
			if not v5 then
				setState(isRobloxPlusFreeTrialEligible(p3))
			end
		end):catch(function()
			if not v5 then
				setState(false)
			end
		end)

		return function()
			v5 = true
		end
	end, {})

	local v6 = if state then p2.freeTrialText else p2.subscribeText
	return { actionText = v6 }
end

return useRobloxPlusUpsellBannerViewModel
