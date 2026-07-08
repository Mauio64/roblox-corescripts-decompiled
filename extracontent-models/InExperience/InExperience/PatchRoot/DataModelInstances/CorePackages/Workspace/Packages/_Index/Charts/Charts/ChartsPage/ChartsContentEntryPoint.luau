local Charts = script:FindFirstAncestor("Charts")
local ChartsParent = Charts.Parent

require(ChartsParent.Navigation)

local React = require(ChartsParent.React)
local AppPage = require(ChartsParent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(ChartsParent.SduiSharedUtilities)
local CompositionTags = require(ChartsParent.AppComposition).CompositionTags
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local fetchChartsPage = require(Charts.ChartsPage.fetchChartsPage)
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)

local function getFromPropsOrNavigationParams(t1: {[any]: any}, s1: string) -- line: 26
	return t1[s1] or t1.navigation and t1.navigation.getParam(s1)
end
local function ChartsContentEntryPoint(t2: {[any]: any}) -- line: 30
	-- upvalues: ChartsConstants (copy), usePageScopeRef (copy), React (copy), getSduiClientPageScope (copy), SduiSurfaceLoadTimeTracker (copy), fetchChartsPage (copy), SduiPageEntryPoint (copy), AppPage (copy), CompositionTags (copy)
	local ConfigKey = ChartsConstants.ConfigKey
	local v19 = t2.pageTimer or t2.navigation and t2.navigation.getParam("pageTimer")

	usePageScopeRef(ConfigKey)

	local v20 = React.useMemo(function() -- line: 35
		-- upvalues: v19 (copy), getSduiClientPageScope (copy), ConfigKey (copy), SduiSurfaceLoadTimeTracker (copy), ChartsConstants (copy)
		if v19 then
			getSduiClientPageScope(ConfigKey).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v19)

			return v19
		end

		local v22 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(ConfigKey, {
			eventName = ChartsConstants.SurfaceLoadTimeEventName,
			metadata = {
				page = "mount"
			}
		})

		v22.start("mount")
		getSduiClientPageScope(ConfigKey).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v22)

		return v22
	end, {
		ConfigKey,
		v19
	})

	React.useEffect(function() -- line: 54
		-- upvalues: fetchChartsPage (copy), v20 (copy)
		fetchChartsPage(v20)
	end, {
		ConfigKey,
		v20
	})

	local v21 = React.useCallback(function() -- line: 58
		-- upvalues: SduiSurfaceLoadTimeTracker (copy), ConfigKey (copy), ChartsConstants (copy), fetchChartsPage (copy)
		local v23 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(ConfigKey, {
			eventName = ChartsConstants.SurfaceLoadTimeEventName,
			metadata = {
				page = "refresh"
			}
		})

		v23.start("refresh")

		return fetchChartsPage(v23, true)
	end, { ConfigKey })

	return React.createElement(SduiPageEntryPoint, {
		includeNavigationHeaderBar = false,
		appPage = AppPage.Games,
		configKey = ConfigKey,
		pageTimer = v20,
		refresh = v21,
		contentTag = CompositionTags.ContentRegion.Body,
		stickyContentTag = CompositionTags.ContentRegion.Header,
		pageTopPadding = t2.pageTopPadding
	})
end

return React.memo(ChartsContentEntryPoint)
