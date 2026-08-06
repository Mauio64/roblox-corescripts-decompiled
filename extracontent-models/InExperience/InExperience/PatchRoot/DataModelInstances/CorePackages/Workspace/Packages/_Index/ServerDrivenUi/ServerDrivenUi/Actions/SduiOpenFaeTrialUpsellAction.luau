local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local getSduiApiStore = require(Parent.SduiSharedUtilities).getSduiApiStore
local startFacialAgeEstimation = require(Parent.SocialUpsell).Thunks.startFacialAgeEstimation
local RobloxSubscriptionPurchaseApp = require(Parent.RobloxSubscriptionPurchaseApp)
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local SubscriptionGrantType = RobloxSubscriptionPurchaseApp.SubscriptionGrantType
local claimTrial = RobloxSubscriptionPurchaseApp.Network.claimTrial
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local SharedFlags = require(Parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagRobloxPlusUpsellRefreshOnComplete = SharedFlags.FFlagRobloxPlusUpsellRefreshOnComplete
local v18 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local v21 = UrlBuilder.new({
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

local function SduiOpenFaeTrialUpsellAction(p1, _, p3) -- line: 45
	-- upvalues: FFlagRobloxPlusUpsellRefreshOnComplete (copy), AppPage (copy), SurfaceName (copy), SurfaceContext (copy), v21 (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), NavigateDown (copy), claimTrial (copy), SubscriptionGrantType (copy), getSduiApiStore (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy), startFacialAgeEstimation (copy)
	local dispatch = p3.dependencies.dispatch
	local localization = p3.dependencies.localization
	local v28 = if not FFlagRobloxPlusUpsellRefreshOnComplete then nil else p1 and p1.actionParams or nil
	local v29 = if not FFlagRobloxPlusUpsellRefreshOnComplete then nil else v28 and v28.promptType
	local v30 = localization:Format("Feature.RobloxSubscription.Title.AgeCheckTrial")
	local v31 = localization:Format("Feature.RobloxSubscription.Description.AgeCheckTrial")
	local v32 = localization:Format("Feature.FAE.Action.Continue")
	local t2 = {
		name = AppPage.RobloxSubscriptionUpsell,
		extraProps = {
			purchaseUIOptions = {
				skipGuacPolicy = true,
				showLegalDisclosure = true,
				noPurchaseMethodRequired = true,
				title = v30,
				description = v31,
				ctaText = v32
			},
			surfaceName = SurfaceName.HomepageFaeTrialBanner,
			surfaceContext = SurfaceContext.InApp,
			onCtaOverride = function(p4, p5) -- line: 79
				-- upvalues: AppPage (copy), v21 (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), dispatch (copy), NavigateDown (copy), claimTrial (copy), SubscriptionGrantType (copy), FFlagRobloxPlusUpsellRefreshOnComplete (copy), getSduiApiStore (copy), v29 (copy), p3 (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy), startFacialAgeEstimation (copy)
				local function openConfirmationWebview(p6) -- line: 80
					-- upvalues: AppPage (copy), v21 (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), dispatch (copy), NavigateDown (copy)
					local t1 = {
						name = AppPage.GenericWebPage,
						detail = v21({
							t = tostring(os.time())
						}),
						extraProps = {
							title = "",
							onClose = p6
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v18.down(v18.fromLegacyPage(t1))

						return
					end

					dispatch(NavigateDown(t1))
				end
				local function onFaeSuccess() -- line: 96
					-- upvalues: claimTrial (copy), SubscriptionGrantType (copy), p4 (copy), FFlagRobloxPlusUpsellRefreshOnComplete (copy), getSduiApiStore (copy), v29 (copy), openConfirmationWebview (copy), p3 (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy)
					claimTrial(SubscriptionGrantType.FaeFreeTrial):andThen(function() -- line: 102
						-- upvalues: p4 (copy), FFlagRobloxPlusUpsellRefreshOnComplete (copy), getSduiApiStore (copy), v29 (copy), openConfirmationWebview (copy)
						local u40 = p4

						if FFlagRobloxPlusUpsellRefreshOnComplete then
							function u40() -- line: 110
								-- upvalues: getSduiApiStore (copy), v29 (copy), p4 (copy)
								local dismissEntry = getSduiApiStore().dismissEntry

								if dismissEntry and typeof(v29) == "string" then
									dismissEntry(v29)
								end

								p4()
							end
						end

						task.delay(1, function() -- line: 122
							-- upvalues: openConfirmationWebview (copy), u40 (ref)
							openConfirmationWebview(u40)
						end)
					end):catch(function(p7) -- line: 126
						-- upvalues: p3 (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy)
						p3.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
							name = SduiActionType.OpenFaeTrialUpsell,
							message = `claimTrial failed: { SduiParseHelpers.stringifyValue(p7) }`
						}, p3.appPage)
					end)
				end

				dispatch(startFacialAgeEstimation("FacialAgeEstimationHomepagePlusFreeTrialBanner", onFaeSuccess, p5, "HomepagePlusFreeTrialBanner", false, true))
			end
		}
	}

	if FFlagSignalsNavP3Dispatch then
		v18.down(v18.fromLegacyPage(t2))

		return
	end

	dispatch(NavigateDown(t2))
end

return SduiOpenFaeTrialUpsellAction
