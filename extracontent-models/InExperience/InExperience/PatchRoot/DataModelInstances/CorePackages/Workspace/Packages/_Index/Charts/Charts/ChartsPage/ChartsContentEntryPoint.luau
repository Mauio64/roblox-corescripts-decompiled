local Charts = script:FindFirstAncestor("Charts")
local parent = Charts.Parent

require(parent.Navigation)
local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local SharedFlags = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026HomeBackground = SharedFlags.FFlagAppThemeHalloween2026HomeBackground

local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local fetchChartsPage = require(Charts.ChartsPage.fetchChartsPage)
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)

local function getFromPropsOrNavigationParams(props, p: string) -- 1 equivalent call inferred from this helper
	return props[p] or props.navigation and props.navigation.getParam(p)
end

local function ChartsContentEntryPoint(props)
	local configKey = ChartsConstants.ConfigKey
	local v = getFromPropsOrNavigationParams(props, "pageTimer") -- inferred equivalent call
	usePageScopeRef(configKey)
	local pageTimer = React.useMemo(function()
		if v then
			getSduiClientPageScope(configKey).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v)

			return v
		end

		local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(configKey, {
			eventName = ChartsConstants.SurfaceLoadTimeEventName,
			metadata = { page = "mount" }
		})

		loadTimerWithSurfaceLoadTime.start("mount")
		getSduiClientPageScope(configKey).set(
			SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY,
			loadTimerWithSurfaceLoadTime
		)
		return loadTimerWithSurfaceLoadTime
	end, { configKey, v })

	React.useEffect(function()
		fetchChartsPage(pageTimer)
	end, { configKey, pageTimer })

	local refresh = React.useCallback(function()
		local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(configKey, {
			eventName = ChartsConstants.SurfaceLoadTimeEventName,
			metadata = { page = "refresh" }
		})

		loadTimerWithSurfaceLoadTime.start("refresh")
		return fetchChartsPage(loadTimerWithSurfaceLoadTime, true)
	end, { configKey })

	local createElement = React.createElement
	local v2 = {
		appPage = AppPage.Games,
		configKey = configKey,
		pageTimer = pageTimer,
		refresh = refresh,
		includeNavigationHeaderBar = false,
		contentTag = CompositionTags.ContentRegion.Body,
		stickyContentTag = CompositionTags.ContentRegion.Header,
		scrollPerformanceIntervalName = ChartsConstants.ScrollPerformanceIntervalName,
		pageTopPadding = props.pageTopPadding,
		feedTopMargin = props.feedTopMargin,
		scrollAway = props.scrollAway,
		backgroundStyle = 0,
		feedBackgroundStyle = 0
	}
	local backgroundStyle

	if FFlagAppThemeHalloween2026HomeBackground then
		backgroundStyle = props.backgroundStyle
	end

	v2.backgroundStyle = backgroundStyle
	local feedBackgroundStyle

	if FFlagAppThemeHalloween2026HomeBackground then
		feedBackgroundStyle = props.backgroundStyle
	end

	v2.feedBackgroundStyle = feedBackgroundStyle
	return createElement(SduiPageEntryPoint, v2)
end

return React.memo(ChartsContentEntryPoint)
