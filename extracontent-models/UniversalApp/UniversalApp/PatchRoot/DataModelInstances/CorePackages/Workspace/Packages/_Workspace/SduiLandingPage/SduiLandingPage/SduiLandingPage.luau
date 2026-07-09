local Parent = script:FindFirstAncestor("SduiLandingPage").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage

require(Parent.Navigation)

local React = require(Parent.React)
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local CompositionTags = require(Parent.AppComposition).CompositionTags
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local fetchSduiLandingPage = require(script.Parent.fetchSduiLandingPage)
local getSduiLandingPageKey = require(script.Parent.getSduiLandingPageKey)
local SduiLandingPageConstants = require(script.Parent.SduiLandingPageConstants)
local SduiLandingPageSession = require(script.Parent.SduiLandingPageSession)

local function getFromPropsOrNavigationParams(t1: {[any]: any}, s1: string) -- line: 28
	local v18 = t1.navigation and t1.navigation.getParam("extraProps")

	return t1[s1] or (v18 and v18[s1] or t1.navigation and t1.navigation.getParam(s1))
end
local function SduiLandingPage(t2: {[any]: any}) -- line: 33
	-- upvalues: getSduiLandingPageKey (copy), usePageScopeRef (copy), React (copy), SduiSurfaceLoadTimeTracker (copy), SduiLandingPageConstants (copy), getSduiClientPageScope (copy), fetchSduiLandingPage (copy), SduiLandingPageSession (copy), SduiPageEntryPoint (copy), AppPage (copy), CompositionTags (copy)
	local v20 = t2.navigation and t2.navigation.getParam("extraProps")
	local v21 = t2.pageIdentifier or (v20 and v20.pageIdentifier or t2.navigation and t2.navigation.getParam("pageIdentifier"))
	local v22 = getSduiLandingPageKey(v21)
	local v23 = t2.navigation and t2.navigation.getParam("extraProps")
	local v24 = t2.pageTimer or (v23 and v23.pageTimer or t2.navigation and t2.navigation.getParam("pageTimer"))

	usePageScopeRef(v22)

	local v25 = React.useMemo(function() -- line: 39
		-- upvalues: v24 (copy), SduiSurfaceLoadTimeTracker (copy), v22 (copy), SduiLandingPageConstants (copy), getSduiClientPageScope (copy)
		local v27 = v24

		if not v27 then
			v27 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v22, {
				eventName = SduiLandingPageConstants.SurfaceLoadTimeEventName,
				metadata = {
					page = "mount"
				}
			})
			v27.start("mount")
		end

		getSduiClientPageScope(v22).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v27)

		return v27
	end, {
		v22,
		v24
	})

	React.useEffect(function() -- line: 54
		-- upvalues: v21 (copy), fetchSduiLandingPage (copy), SduiLandingPageSession (copy), v25 (copy)
		if v21 then
			fetchSduiLandingPage(v21, SduiLandingPageSession:Get(), v25)
		end
	end, {
		v21,
		v25
	})

	local v26 = React.useCallback(function() -- line: 60
		-- upvalues: v21 (copy), SduiSurfaceLoadTimeTracker (copy), v22 (copy), SduiLandingPageConstants (copy), fetchSduiLandingPage (copy), SduiLandingPageSession (copy)
		if v21 then
			local v28 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v22, {
				eventName = SduiLandingPageConstants.SurfaceLoadTimeEventName,
				metadata = {
					page = "refresh"
				}
			})

			v28.start("refresh")
			fetchSduiLandingPage(v21, SduiLandingPageSession:Refresh(), v28, true)
		end
	end, {
		v21,
		v22
	})

	if v21 == nil or v21 == "" then
		return nil
	end

	return React.createElement(SduiPageEntryPoint, {
		includeNavigationHeaderBar = true,
		appPage = AppPage.SduiLandingPage,
		configKey = v22,
		pageTimer = v25,
		refresh = v26,
		contentTag = CompositionTags.ContentRegion.Body
	})
end

return React.memo(SduiLandingPage)
