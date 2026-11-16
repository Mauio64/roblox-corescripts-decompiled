local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fzr")
local robloxSubscriptionFlowCompleteReason = module.RobloxSubscriptionFlowCompleteReason
local surfaceName = module.SurfaceName
local surfaceContext = module.SurfaceContext

local module2 = require("@luauforge/deferred/gqU")

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

return function(props)
	local v5 = useNavigation()

	React.useEffect(function()
		local initiateRobloxSubscriptionPurchase = module.initiateRobloxSubscriptionPurchase
		local purchaseUIOptions = props.purchaseUIOptions
		local v6 = {
			onCtaOverride = props.onCtaOverride,
			onFlowComplete = function(p2)
				if p2 == robloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
					if props.onSuccess then
						props.onSuccess()
					else
						v5.goBack()
					end
				elseif
					p2 == robloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed
					and props.onFailure
				then
					props.onFailure()
				elseif props.onCancel then
					props.onCancel()
				else
					v5.goBack()
				end
			end
		}

		local surfaceName2 = props.surfaceName or surfaceName.Unspecified
		local surfaceContext2 = props.surfaceContext or surfaceContext.Unspecified

		local v9 = if module2 then props.analyticsContext else nil
		local v10 = initiateRobloxSubscriptionPurchase(
			purchaseUIOptions,
			v6,
			nil,
			surfaceName2,
			surfaceContext2,
			nil,
			v9
		)

		return function()
			if v10 then
				v10()
			end
		end
	end, {})

	return React.createElement(React.Fragment, {})
end
