local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RobloxSubscriptionPurchaseApp = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp)
local RobloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local FFlagRobloxPlusFAEFreeTrial = RobloxSubscriptionPurchaseApp.FFlagRobloxPlusFAEFreeTrial
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: FFlagRobloxPlusFAEFreeTrial (copy), useNavigation (copy), React (copy), RobloxSubscriptionPurchaseApp (copy), RobloxSubscriptionFlowCompleteReason (copy), SurfaceName (copy), SurfaceContext (copy)
	local v10 = if not FFlagRobloxPlusFAEFreeTrial then nil else useNavigation()

	React.useEffect(function() -- line: 27
		-- upvalues: RobloxSubscriptionPurchaseApp (copy), t1 (copy), FFlagRobloxPlusFAEFreeTrial (copy), RobloxSubscriptionFlowCompleteReason (copy), v10 (copy), SurfaceName (copy), SurfaceContext (copy)
		local v11 = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase(t1.purchaseUIOptions, {
			onCtaOverride = if not FFlagRobloxPlusFAEFreeTrial then nil else t1.onCtaOverride,
			onFlowComplete = function(p1) -- line: 32
				-- upvalues: RobloxSubscriptionFlowCompleteReason (copy), t1 (copy), FFlagRobloxPlusFAEFreeTrial (copy), v10 (copy)
				if p1 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
					if t1.onSuccess then
						t1.onSuccess()

						return
					end

					if FFlagRobloxPlusFAEFreeTrial then
						v10.goBack()

						return
					end
				elseif p1 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
					if t1.onFailure then
						t1.onFailure()

						return
					end

					if t1.onCancel then
						t1.onCancel()

						return
					end

					if FFlagRobloxPlusFAEFreeTrial then
						v10.goBack()

						return
					end
				else
					if t1.onCancel then
						t1.onCancel()

						return
					end

					if FFlagRobloxPlusFAEFreeTrial then
						v10.goBack()
					end
				end
			end
		}, nil, t1.surfaceName or SurfaceName.Unspecified, t1.surfaceContext or SurfaceContext.Unspecified)

		return function() -- line: 61
			-- upvalues: v11 (copy)
			if v11 then
				v11()
			end
		end
	end, {})

	return React.createElement(React.Fragment, {})
end
