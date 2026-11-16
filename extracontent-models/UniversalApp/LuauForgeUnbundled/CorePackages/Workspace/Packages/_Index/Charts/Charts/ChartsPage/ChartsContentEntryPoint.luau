require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/React")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SduiSharedUtilities")
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/AppComposition").CompositionTags

local fFlagAppThemeHalloween2026HomeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SharedFlags").FFlagAppThemeHalloween2026HomeBackground

local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local fetchChartsPage = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/fetchChartsPage")
local ChartsConstants = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsConstants")

local function getFromPropsOrNavigationParams(p2, p3)
	return p2[p3] or p2.navigation and p2.navigation.getParam(p3)
end

local function ChartsContentEntryPoint(props)
	local configKey = ChartsConstants.ConfigKey
	local pageTimer = props.pageTimer or props.navigation and props.navigation.getParam("pageTimer")

	usePageScopeRef(configKey)
	local v5 = React.useMemo(function()
		if pageTimer then
			getSduiClientPageScope(configKey).set(
				sduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY,
				pageTimer
			)

			return pageTimer
		end

		local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
			configKey,
			{
				eventName = ChartsConstants.SurfaceLoadTimeEventName,
				metadata = { page = "mount" }
			}
		)

		loadTimerWithSurfaceLoadTime.start("mount")
		getSduiClientPageScope(configKey).set(
			sduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY,
			loadTimerWithSurfaceLoadTime
		)
		return loadTimerWithSurfaceLoadTime
	end, { configKey, pageTimer })

	React.useEffect(function()
		fetchChartsPage(v5)
	end, { configKey, v5 })

	local v6 = React.useCallback(function()
		local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
			configKey,
			{
				eventName = ChartsConstants.SurfaceLoadTimeEventName,
				metadata = { page = "refresh" }
			}
		)

		loadTimerWithSurfaceLoadTime.start("refresh")
		return fetchChartsPage(loadTimerWithSurfaceLoadTime, true)
	end, { configKey })

	local createElement = React.createElement
	local v8 = {
		appPage = appPage.Games,
		configKey = configKey,
		pageTimer = v5,
		refresh = v6,
		includeNavigationHeaderBar = false,
		contentTag = compositionTags.ContentRegion.Body,
		stickyContentTag = compositionTags.ContentRegion.Header,
		scrollPerformanceIntervalName = ChartsConstants.ScrollPerformanceIntervalName,
		pageTopPadding = props.pageTopPadding,
		feedTopMargin = props.feedTopMargin,
		scrollAway = props.scrollAway,
		backgroundStyle = 0,
		feedBackgroundStyle = 0
	}
	local v9 = if fFlagAppThemeHalloween2026HomeBackground then props.backgroundStyle else nil
	v8.backgroundStyle = v9
	local v10 = if fFlagAppThemeHalloween2026HomeBackground then props.backgroundStyle else nil
	v8.feedBackgroundStyle = v10
	return createElement(sduiPageEntryPoint, v8)
end

return React.memo(ChartsContentEntryPoint)
