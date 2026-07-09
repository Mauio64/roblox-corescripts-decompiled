local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local NavigateFromWebView = require(Parent.NavigationRodux).Thunks.NavigateFromWebView
local NavigateBack = require(Parent.NavigationRodux).Thunks.NavigateBack
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableAmpWizardDeepLink = SharedFlags.FFlagEnableAmpWizardDeepLink
local FFlagLuaAppWizardContainerBypassNavigationLock = require(Parent.SharedFlags).FFlagLuaAppWizardContainerBypassNavigationLock
local FFlagLuaAppPlayButtonWizardCloseDelay = SharedFlags.FFlagLuaAppPlayButtonWizardCloseDelay
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

return function(p1, p2, p3, p4, p5, s1: string?, b1: boolean?, p6, p7: ((...any) -> ...any)?, b2: boolean?) -- line: 18
	-- upvalues: FFlagEnableAmpWizardDeepLink (copy), AppPage (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), FFlagLuaAppWizardContainerBypassNavigationLock (copy), NavigateBack (copy), NavigateFromWebView (copy), NavigateDown (copy)
	local v22 = FFlagEnableAmpWizardDeepLink and (p6 ~= nil and p6.returnPage ~= nil)

	return function(p8) -- line: 32
		-- upvalues: AppPage (copy), p1 (copy), p3 (copy), p4 (copy), s1 (copy), p5 (copy), p6 (copy), FFlagLuaAppPlayButtonWizardCloseDelay (copy), p7 (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), FFlagLuaAppWizardContainerBypassNavigationLock (copy), NavigateBack (copy), p2 (copy), b1 (copy), b2 (copy), v22 (copy), NavigateFromWebView (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = p1,
				recourseData = p3,
				entryPointEventCtx = p4,
				nameSpace = s1,
				extraParameters = p5,
				metadata = p6,
				completionCallback = function(p9, p10) -- line: 42
					-- upvalues: FFlagLuaAppPlayButtonWizardCloseDelay (copy), p7 (copy), p8 (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), FFlagLuaAppWizardContainerBypassNavigationLock (copy), NavigateBack (copy), p2 (copy)
					if FFlagLuaAppPlayButtonWizardCloseDelay and p7 then
						p7(p8, p9, p10)

						return
					end

					if FFlagSignalsNavP3Dispatch then
						v11.back(not not FFlagLuaAppWizardContainerBypassNavigationLock or nil)
					else
						p8:dispatch(NavigateBack(not not FFlagLuaAppWizardContainerBypassNavigationLock or nil))
					end

					p2(p9, p10)
				end,
				skipFacialAgeEstimationWebLinkModal = b1,
				usePrologue = b2
			}
		}

		if v22 then
			if FFlagSignalsNavP3Dispatch then
				v11.fromWebView(v11.fromLegacyPage(t1), true)

				return
			end

			p8:dispatch(NavigateFromWebView(t1, true))

			return
		end

		if FFlagSignalsNavP3Dispatch then
			v11.down(v11.fromLegacyPage(t1), true)

			return
		end

		p8:dispatch(NavigateDown(t1, true))
	end
end
