local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").getSduiApiStore
local setPromptDismissedInPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/PromptsServerDrivenUi").setPromptDismissedInPageScope
local startFacialAgeEstimation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SocialUpsell").Thunks.startFacialAgeEstimation
local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxSubscriptionPurchaseApp")
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local subscriptionGrantType = RobloxSubscriptionPurchaseApp.SubscriptionGrantType
local claimTrial = RobloxSubscriptionPurchaseApp.Network.claimTrial

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux").Thunks.NavigateDown
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagRobloxPlusUpsellRefreshOnComplete = SharedFlags.FFlagRobloxPlusUpsellRefreshOnComplete
local fFlagSduiDismissPromptPageScope = SharedFlags.FFlagSduiDismissPromptPageScope

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UrlBuilder").UrlBase

local v5 = urlBuilder.new({
	base = urlBase.WWW,
	path = "plus",
	query = {
		{ name = "faeFreeTrialConfirmation", value = "true", optional = false },
		{ name = "t", value = "{t}", optional = false }
	}
})

local function SduiOpenFaeTrialUpsellAction(p2, p3, data)
	local dispatch = data.dependencies.dispatch
	local localization = data.dependencies.localization

	local actionParams = if fFlagRobloxPlusUpsellRefreshOnComplete then p2 and p2.actionParams or nil else nil
	local promptType

	if fFlagRobloxPlusUpsellRefreshOnComplete then
		promptType = actionParams and actionParams.promptType
	else
		promptType = nil
	end

	local formatted = localization:Format("Feature.RobloxSubscription.Title.AgeCheckTrial")
	local formatted2 = localization:Format("Feature.RobloxSubscription.Description.AgeCheckTrial")
	local formatted3 = localization:Format("Feature.FAE.Action.Continue")

	local v6 = {
		name = appPage.RobloxSubscriptionUpsell,
		extraProps = {
			purchaseUIOptions = {
				title = formatted,
				description = formatted2,
				ctaText = formatted3,
				skipGuacPolicy = true,
				showLegalDisclosure = true,
				noPurchaseMethodRequired = true
			},
			surfaceName = surfaceName.HomepageFaeTrialBanner,
			surfaceContext = surfaceContext.InApp,
			onCtaOverride = function(callback, p4)
				local function openConfirmationWebview(onClose)
					local v7 = {
						name = appPage.GenericWebPage,
						detail = v5({ t = tostring(os.time()) }),
						extraProps = { title = "", onClose = onClose }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v7))
					else
						dispatch(navigateDown(v7))
					end
				end

				local function onFaeSuccess()
					claimTrial(subscriptionGrantType.FaeFreeTrial):andThen(function()
						local fn = fFlagRobloxPlusUpsellRefreshOnComplete and function()
							local dismissEntry = getSduiApiStore().dismissEntry

							if fFlagSduiDismissPromptPageScope then
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
					end):catch(function(p5)
						data.dependencies.logger.reportError(
							sduiErrorType.ActionNetworkRequestFailed,
							{
								name = sduiActionType.OpenFaeTrialUpsell,
								message = `claimTrial failed: {sduiParseHelpers.stringifyValue(p5)}`
							},
							data.appPage
						)
					end)
				end

				dispatch(startFacialAgeEstimation(
					"FacialAgeEstimationHomepagePlusFreeTrialBanner",
					onFaeSuccess,
					p4,
					"HomepagePlusFreeTrialBanner",
					false,
					true
				))
			end
		}
	}

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v6))
	else
		dispatch(navigateDown(v6))
	end
end

return SduiOpenFaeTrialUpsellAction
