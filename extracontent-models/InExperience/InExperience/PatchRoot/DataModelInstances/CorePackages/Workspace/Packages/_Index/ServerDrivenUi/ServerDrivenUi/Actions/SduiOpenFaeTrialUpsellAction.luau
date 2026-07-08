local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local startFacialAgeEstimation = require(Parent.SocialUpsell).Thunks.startFacialAgeEstimation
local RobloxSubscriptionPurchaseApp = require(Parent.RobloxSubscriptionPurchaseApp)
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local SubscriptionGrantType = RobloxSubscriptionPurchaseApp.SubscriptionGrantType
local claimTrial = RobloxSubscriptionPurchaseApp.Network.claimTrial
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v15 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local v18 = UrlBuilder.new({
	path = "plus",
	base = UrlBase.WWW,
	query = {
		{
			name = "faeFreeTrialConfirmation",
			value = "true",
			optional = false
		},
		{
			name = "t",
			value = "{t}",
			optional = false
		}
	}
})

local function SduiOpenFaeTrialUpsellAction(_, _, p3) -- line: 41
	-- upvalues: AppPage (copy), SurfaceName (copy), SurfaceContext (copy), v18 (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), NavigateDown (copy), claimTrial (copy), SubscriptionGrantType (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy), startFacialAgeEstimation (copy)
	local dispatch = p3.dependencies.dispatch
	local localization = p3.dependencies.localization
	local v25 = localization:Format("Feature.RobloxSubscription.Title.AgeCheckTrial")
	local v26 = localization:Format("Feature.RobloxSubscription.Description.AgeCheckTrial")
	local v27 = localization:Format("Feature.FAE.Action.Continue")
	local t2 = {
		name = AppPage.RobloxSubscriptionUpsell,
		extraProps = {
			purchaseUIOptions = {
				skipGuacPolicy = true,
				showLegalDisclosure = true,
				noPurchaseMethodRequired = true,
				title = v25,
				description = v26,
				ctaText = v27
			},
			surfaceName = SurfaceName.HomepageFaeTrialBanner,
			surfaceContext = SurfaceContext.InApp,
			onCtaOverride = function(p4, p5) -- line: 66
				-- upvalues: AppPage (copy), v18 (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), dispatch (copy), NavigateDown (copy), claimTrial (copy), SubscriptionGrantType (copy), p3 (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy), startFacialAgeEstimation (copy)
				local function openConfirmationWebview() -- line: 67
					-- upvalues: AppPage (copy), v18 (copy), p4 (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), dispatch (copy), NavigateDown (copy)
					local t1 = {
						name = AppPage.GenericWebPage,
						detail = v18({
							t = tostring(os.time())
						}),
						extraProps = {
							title = "",
							onClose = p4
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v15.down(v15.fromLegacyPage(t1))

						return
					end

					dispatch(NavigateDown(t1))
				end
				local function onFaeSuccess() -- line: 83
					-- upvalues: claimTrial (copy), SubscriptionGrantType (copy), openConfirmationWebview (copy), p3 (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy)
					claimTrial(SubscriptionGrantType.FaeFreeTrial):andThen(function() -- line: 89
						-- upvalues: openConfirmationWebview (copy)
						task.delay(1, openConfirmationWebview)
					end):catch(function(p6) -- line: 92
						-- upvalues: p3 (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy)
						p3.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
							name = SduiActionType.OpenFaeTrialUpsell,
							message = `claimTrial failed: { SduiParseHelpers.stringifyValue(p6) }`
						}, p3.appPage)
					end)
				end

				dispatch(startFacialAgeEstimation("FacialAgeEstimationHomepagePlusFreeTrialBanner", onFaeSuccess, p5, "HomepagePlusFreeTrialBanner", false, true))
			end
		}
	}

	if FFlagSignalsNavP3Dispatch then
		v15.down(v15.fromLegacyPage(t2))

		return
	end

	dispatch(NavigateDown(t2))
end

return SduiOpenFaeTrialUpsellAction
