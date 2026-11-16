local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
require(AmpUpsell.Common.Types)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigationRodux2 = require(parent.NavigationRodux)
local NavigateFromWebView = NavigationRodux2.Thunks.NavigateFromWebView
local NavigationRodux3 = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux3.Thunks.NavigateBack
local NavigationRodux4 = require(parent.NavigationRodux)
local Selectors = NavigationRodux4.Selectors
local SharedFlags = require(parent.SharedFlags)
local FFlagAmpWizardDeepLinkReplaceOnlyWebView = require(AmpUpsell.Flags.FFlagAmpWizardDeepLinkReplaceOnlyWebView)
local FFlagEnableAmpWizardDeepLink = SharedFlags.FFlagEnableAmpWizardDeepLink

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppWizardContainerBypassNavigationLock = SharedFlags2.FFlagLuaAppWizardContainerBypassNavigationLock
local FFlagLuaAppPlayButtonWizardCloseDelay = SharedFlags.FFlagLuaAppPlayButtonWizardCloseDelay
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local getLegacyNavigationStore

if FFlagSignalsNavP3Dispatch then
	local NavigationRodux5 = require(parent.NavigationRodux)
	getLegacyNavigationStore = NavigationRodux5.GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

return function(featureName, callback, recourseData, entryPointEventCtx, extraParameters, nameSpace: string?, skipFacialAgeEstimationWebLinkModal: boolean?, metadata, callback2, usePrologue: boolean?, prologueOptions)
	local v = FFlagEnableAmpWizardDeepLink

	if v then
		if metadata == nil then
			v = false
		else
			v = metadata.returnPage ~= nil
		end
	end

	return function(object)
		local v2 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = featureName,
				recourseData = recourseData,
				entryPointEventCtx = entryPointEventCtx,
				nameSpace = nameSpace,
				extraParameters = extraParameters,
				metadata = metadata,
				completionCallback = function(p, p2)
					if FFlagLuaAppPlayButtonWizardCloseDelay and callback2 then
						callback2(object, p, p2)
						return
					end

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.back(FFlagLuaAppWizardContainerBypassNavigationLock and true or nil)
					else
						object:dispatch(NavigateBack(FFlagLuaAppWizardContainerBypassNavigationLock and true or nil))
					end

					callback(p, p2)
				end,
				skipFacialAgeEstimationWebLinkModal = skipFacialAgeEstimationWebLinkModal,
				usePrologue = usePrologue,
				prologueOptions = prologueOptions
			}
		}

		if FFlagAmpWizardDeepLinkReplaceOnlyWebView and v then
			local v3

			if FFlagSignalsNavP3Dispatch then
				v3 = getLegacyNavigationStore(false).getCurrentPageName(false)
			else
				v3 = Selectors.selectCurrentPageName(object:getState())
			end

			local v4 = v3 == AppPage.GenericWebPage
			v = v and v4
		end

		if v then
			if FFlagSignalsNavP3Dispatch then
				navigationCommands.fromWebView(navigationCommands.fromLegacyPage(v2), true)
			else
				object:dispatch(NavigateFromWebView(v2, true))
			end
		elseif FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v2), true)
		else
			object:dispatch(NavigateDown(v2, true))
		end
	end
end
