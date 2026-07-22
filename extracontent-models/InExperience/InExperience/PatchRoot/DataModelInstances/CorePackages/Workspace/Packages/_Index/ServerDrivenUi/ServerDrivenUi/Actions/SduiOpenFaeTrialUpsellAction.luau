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
local FFlagDismissInlineBannerOnCtaClick = SharedFlags.FFlagDismissInlineBannerOnCtaClick
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local v22 = UrlBuilder.new({
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

local function SduiOpenFaeTrialUpsellAction(p1, _, p3) -- line: 46
	-- upvalues: FFlagRobloxPlusUpsellRefreshOnComplete (copy), AppPage (copy), SurfaceName (copy), SurfaceContext (copy), v22 (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy), claimTrial (copy), SubscriptionGrantType (copy), getSduiApiStore (copy), FFlagDismissInlineBannerOnCtaClick (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy), startFacialAgeEstimation (copy)
	local dispatch = p3.dependencies.dispatch
	local localization = p3.dependencies.localization
	local v29 = if not FFlagRobloxPlusUpsellRefreshOnComplete then nil else p1 and p1.actionParams or nil
	local v30 = if not FFlagRobloxPlusUpsellRefreshOnComplete then nil else v29 and v29.promptType
	local v31 = if not FFlagRobloxPlusUpsellRefreshOnComplete then nil else v29 and v29.configKey or "Home"
	local v32 = localization:Format("Feature.RobloxSubscription.Title.AgeCheckTrial")
	local v33 = localization:Format("Feature.RobloxSubscription.Description.AgeCheckTrial")
	local v34 = localization:Format("Feature.FAE.Action.Continue")
	local t2 = {
		name = AppPage.RobloxSubscriptionUpsell,
		extraProps = {
			purchaseUIOptions = {
				skipGuacPolicy = true,
				showLegalDisclosure = true,
				noPurchaseMethodRequired = true,
				title = v32,
				description = v33,
				ctaText = v34
			},
			surfaceName = SurfaceName.HomepageFaeTrialBanner,
			surfaceContext = SurfaceContext.InApp,
			onCtaOverride = function(p4, p5) -- line: 85
				-- upvalues: AppPage (copy), v22 (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), dispatch (copy), NavigateDown (copy), claimTrial (copy), SubscriptionGrantType (copy), FFlagRobloxPlusUpsellRefreshOnComplete (copy), getSduiApiStore (copy), v30 (copy), FFlagDismissInlineBannerOnCtaClick (copy), v31 (copy), p3 (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy), startFacialAgeEstimation (copy)
				local function openConfirmationWebview(p6) -- line: 86
					-- upvalues: AppPage (copy), v22 (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), dispatch (copy), NavigateDown (copy)
					local t1 = {
						name = AppPage.GenericWebPage,
						detail = v22({
							t = tostring(os.time())
						}),
						extraProps = {
							title = "",
							onClose = p6
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v19.down(v19.fromLegacyPage(t1))

						return
					end

					dispatch(NavigateDown(t1))
				end
				local function onFaeSuccess() -- line: 102
					-- upvalues: claimTrial (copy), SubscriptionGrantType (copy), p4 (copy), FFlagRobloxPlusUpsellRefreshOnComplete (copy), getSduiApiStore (copy), v30 (copy), FFlagDismissInlineBannerOnCtaClick (copy), v31 (copy), openConfirmationWebview (copy), p3 (copy), SduiErrorType (copy), SduiActionType (copy), SduiParseHelpers (copy)
					claimTrial(SubscriptionGrantType.FaeFreeTrial):andThen(function() -- line: 108
						-- upvalues: p4 (copy), FFlagRobloxPlusUpsellRefreshOnComplete (copy), getSduiApiStore (copy), v30 (copy), FFlagDismissInlineBannerOnCtaClick (copy), v31 (copy), openConfirmationWebview (copy)
						local u42 = p4

						if FFlagRobloxPlusUpsellRefreshOnComplete then
							function u42() -- line: 116
								-- upvalues: getSduiApiStore (copy), v30 (copy), FFlagDismissInlineBannerOnCtaClick (copy), v31 (copy), p4 (copy)
								local v44 = getSduiApiStore()
								local dismissEntry = v44.dismissEntry

								if dismissEntry then
									if typeof(v30) == "string" then
										dismissEntry(v30)
									elseif FFlagDismissInlineBannerOnCtaClick and typeof(v31) == "string" then
										local v46 = v44.getData(v31).data(false)

										if v46 then
											for _, v48 in v46 do
												if v48.category == "InlineBanner" and typeof(v48.title) == "string" then
													dismissEntry(v48.title)
												end
											end
										end
									end
								end

								p4()
							end
						end

						task.delay(1, function() -- line: 144
							-- upvalues: openConfirmationWebview (copy), u42 (ref)
							openConfirmationWebview(u42)
						end)
					end):catch(function(p7) -- line: 148
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
		v19.down(v19.fromLegacyPage(t2))

		return
	end

	dispatch(NavigateDown(t2))
end

return SduiOpenFaeTrialUpsellAction
