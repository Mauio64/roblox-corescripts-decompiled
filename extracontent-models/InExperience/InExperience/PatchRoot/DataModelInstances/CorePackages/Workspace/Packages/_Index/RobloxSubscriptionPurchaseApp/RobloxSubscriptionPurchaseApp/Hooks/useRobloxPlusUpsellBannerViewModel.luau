local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)

local getRobloxSubscriptionProducts = require(RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProducts)
local isRobloxPlusFreeTrialEligible = require(RobloxSubscriptionPurchaseApp.Utils.isRobloxPlusFreeTrialEligible)

local function useRobloxPlusUpsellBannerViewModel(p)
	local state, setState = React.useState(false)

	React.useEffect(function()
		local v = false
		getRobloxSubscriptionProducts():andThen(function(p2)
			if not v then
				setState(isRobloxPlusFreeTrialEligible(p2))
			end
		end):catch(function()
			if not v then
				setState(false)
			end
		end)

		return function()
			v = true
		end
	end, {})
	local actionText

	if state then
		actionText = p.freeTrialText
	else
		actionText = p.subscribeText
	end

	return { actionText = actionText }
end

return useRobloxPlusUpsellBannerViewModel
