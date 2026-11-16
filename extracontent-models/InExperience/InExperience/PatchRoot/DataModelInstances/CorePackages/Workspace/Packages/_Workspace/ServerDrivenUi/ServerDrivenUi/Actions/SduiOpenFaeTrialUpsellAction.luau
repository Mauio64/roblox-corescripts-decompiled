local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local PromptsServerDrivenUi = require(parent.PromptsServerDrivenUi)
local setPromptDismissedInPageScope = PromptsServerDrivenUi.setPromptDismissedInPageScope
local SocialUpsell = require(parent.SocialUpsell)
local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local SubscriptionGrantType = RobloxSubscriptionPurchaseApp.SubscriptionGrantType
local claimTrial = RobloxSubscriptionPurchaseApp.Network.claimTrial

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagRobloxPlusUpsellRefreshOnComplete = SharedFlags.FFlagRobloxPlusUpsellRefreshOnComplete
local FFlagSduiDismissPromptPageScope = SharedFlags.FFlagSduiDismissPromptPageScope
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local v = urlBuilder.new({
	base = UrlBase.WWW,
	path = "plus",
	query = {
		{ name = "faeFreeTrialConfirmation", value = "true", optional = false },
		{ name = "t", value = "{t}", optional = false }
	}
})

local function SduiOpenFaeTrialUpsellAction(p, _, data)
	local dispatch = data.dependencies.dispatch
	local localization = data.dependencies.localization
	local actionParams

	if FFlagRobloxPlusUpsellRefreshOnComplete then
		actionParams = p and p.actionParams or nil
	end

	local promptType

	if FFlagRobloxPlusUpsellRefreshOnComplete then
		promptType = actionParams and actionParams.promptType
	else
		promptType = nil
	end

	local formatted = localization:Format("Feature.RobloxSubscription.Title.AgeCheckTrial")
	local formatted2 = localization:Format("Feature.RobloxSubscription.Description.AgeCheckTrial")
	local formatted3 = localization:Format("Feature.FAE.Action.Continue")

	local v2 = {
		name = AppPage.RobloxSubscriptionUpsell,
		extraProps = {
			purchaseUIOptions = {
				title = formatted,
				description = formatted2,
				ctaText = formatted3,
				skipGuacPolicy = true,
				showLegalDisclosure = true,
				noPurchaseMethodRequired = true
			},
			surfaceName = SurfaceName.HomepageFaeTrialBanner,
			surfaceContext = SurfaceContext.InApp,
			onCtaOverride = function(callback, p2)
				local function openConfirmationWebview(onClose)
					local v2 = {
						name = AppPage.GenericWebPage,
						detail = v({ t = tostring(os.time()) }),
						extraProps = { title = "", onClose = onClose }
					}

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v2))
					else
						dispatch(NavigateDown(v2))
					end
				end

				local function onFaeSuccess()
					claimTrial(SubscriptionGrantType.FaeFreeTrial):andThen(function()
						local fn = FFlagRobloxPlusUpsellRefreshOnComplete and function()
							local dismissEntry = getSduiApiStore().dismissEntry

							if FFlagSduiDismissPromptPageScope then
								if typeof(promptType) == "string" then
									if dismissEntry then
										dismissEntry(promptType)
									end

									if typeof(data.configKey) == "string" and data.configKey ~= "" then
										setPromptDismissedInPageScope(data.configKey, promptType)
									end
								end
							elseif dismissEntry and typeof(promptType) == "string" then
								dismissEntry(promptType)
							end

							callback()
						end or callback

						task.delay(1, function()
							openConfirmationWebview(fn)
						end)
					end):catch(function(p3)
						data.dependencies.logger.reportError(
							SduiErrorType.ActionNetworkRequestFailed,
							{
								name = SduiActionType.OpenFaeTrialUpsell,
								message = `claimTrial failed: {SduiParseHelpers.stringifyValue(p3)}`
							},
							data.appPage
						)
					end)
				end

				dispatch(startFacialAgeEstimation(
					"FacialAgeEstimationHomepagePlusFreeTrialBanner",
					onFaeSuccess,
					p2,
					"HomepagePlusFreeTrialBanner",
					false,
					true
				))
			end
		}
	}

	if FFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v2))
	else
		dispatch(NavigateDown(v2))
	end
end

return SduiOpenFaeTrialUpsellAction
