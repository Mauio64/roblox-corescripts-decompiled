local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Types")
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/NavigationRodux").Thunks.NavigateDown
local navigateFromWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/NavigationRodux").Thunks.NavigateFromWebView
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/NavigationRodux").Thunks.NavigateBack
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/NavigationRodux").Selectors
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags")
local FFlagAmpWizardDeepLinkReplaceOnlyWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/FFlagAmpWizardDeepLinkReplaceOnlyWebView")
local fFlagEnableAmpWizardDeepLink = SharedFlags.FFlagEnableAmpWizardDeepLink

local fFlagLuaAppWizardContainerBypassNavigationLock = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags").FFlagLuaAppWizardContainerBypassNavigationLock
local fFlagLuaAppPlayButtonWizardCloseDelay = SharedFlags.FFlagLuaAppPlayButtonWizardCloseDelay
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppNavigation").NavigationCommands else nil

local getLegacyNavigationStore = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/NavigationRodux").GetLegacyNavigationStore else nil

return function(p2, callback, p3, p4, p5, p6, p7, p8, callback2, p9, p10)
	local v5 = fFlagEnableAmpWizardDeepLink

	if v5 then
		v5 = not (p8 == nil) and p8.returnPage ~= nil
	end

	return function(object)
		local v6 = {
			name = appPage.AmpWizardContainer,
			extraProps = {
				featureName = p2,
				recourseData = p3,
				entryPointEventCtx = p4,
				nameSpace = p6,
				extraParameters = p5,
				metadata = p8,
				completionCallback = function(p11, p12)
					if fFlagLuaAppPlayButtonWizardCloseDelay and callback2 then
						callback2(object, p11, p12)
						return
					end

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.back(fFlagLuaAppWizardContainerBypassNavigationLock and true or nil)
					else
						object:dispatch(navigateBack(fFlagLuaAppWizardContainerBypassNavigationLock and true or nil))
					end

					callback(p11, p12)
				end,
				skipFacialAgeEstimationWebLinkModal = p7,
				usePrologue = p9,
				prologueOptions = p10
			}
		}

		if FFlagAmpWizardDeepLinkReplaceOnlyWebView and v5 then
			local v8 = (if fFlagSignalsNavP3Dispatch then getLegacyNavigationStore(false).getCurrentPageName(false) else selectors.selectCurrentPageName(object:getState())) == appPage.GenericWebPage
			v5 = v5 and v8
		end

		if v5 then
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.fromWebView(navigationCommands.fromLegacyPage(v6), true)
			else
				object:dispatch(navigateFromWebView(v6, true))
			end
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6), true)
		else
			object:dispatch(navigateDown(v6, true))
		end
	end
end
